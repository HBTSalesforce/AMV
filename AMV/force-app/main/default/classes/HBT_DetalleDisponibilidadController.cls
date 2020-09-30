/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase que administra el funcionamiento del detalle de disponibilidad
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
public class HBT_DetalleDisponibilidadController {
    /**
     * getPickListSalaValues obtiene las salas para que sean mostradas en una lista de seleccion
     * @return List < Map < String, String >>: Lista con los valores de las salas disponibles para mostrar
     */
    @AuraEnabled
    public static List < Map < String, String >> getPickListSalaValues(string tipo) {
        system.debug('salas valores '+tipo);
        List < Map < String, String >> options = new List < Map < String, String >> ();
        List<HBT_Sala__c> salas = new List<HBT_Sala__c>();
        if(tipo != null && tipo != ''){
            if(tipo != 'Virtual'){
                tipo = 'Física';
            }
            salas = [select id, name, Tipo_sala__c  from HBT_Sala__c where estado__c = 'Activo' and Tipo_sala__c = :tipo order by name];
            
        }else{
            salas = [select id, name, Tipo_sala__c  from HBT_Sala__c where estado__c = 'Activo' order by name];
        }
        
        if(salas.size() > 0){
            for (HBT_Sala__c f: salas){
                Map < String, String > values = new Map < String, String >();
                values.put('label', f.name);
                values.put('value', f.id);
                
                options.add(values);
            }
        }
        return options;
    }
    /**
     * getPickListDuracionValues obtiene los valores disponibles de Duracion (duracion__c) para mostrar
     * @return List < Map < String, String >>: Lista con los valores de las duraciones disponibles para mostrar
     */
    @AuraEnabled
    public static List < Map < String, String >> getPickListDuracionValues() {
        system.debug('duracion valores');
        List < Map < String, String >> options = new List < Map < String, String >> ();
        Map < String, Schema.SObjectType > objGlobalMap = Schema.getGlobalDescribe();
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('HBT_Parametrizacion_disponibilidad__c');
        
        if (objType == null) {
            return options;
        }
        Schema.DescribeSObjectResult sobjectDescribe = objType.getDescribe();
        
        Map < String, Schema.SObjectField > fieldMap = sobjectDescribe.fields.getMap();
        system.debug('fieldMap '+fieldMap);
        if (fieldMap.get('duracion__c') == null) {
            return options;
        }
        List < Schema.PicklistEntry > pickListValues = fieldMap.get('duracion__c').getDescribe().getPickListValues();
        system.debug('pickListValues '+pickListValues.size());
        for (Schema.PicklistEntry f: pickListValues) {
            Map < String, String > values = new Map < String, String > {
                'label' => f.getLabel(),
                    'value' => f.getValue()
                    };
                        options.add(values);
        }
        return options;
    }
    /**
* getCalendarioList obtiene los valores de los meses con su respectiva disponibilidad
@param fecha, representa la fecha que se va a consultar
@param sala, representa la sala de la cual se va a consultar la disponibilidad
@param duracion, representa la duracion de la cual se va a consultar la disponibilidad
* @return List<Tablacalendario>: Lista con los valores de los dias del mes con sus festivos y su disponibilidad
*/
    @AuraEnabled(cacheable=true)
    public static List<Tablacalendario> getCalendarioList(string fecha, string sala, string duracion) {
        system.debug('fecha '+fecha);
        system.debug('sala '+sala);
        system.debug('duracion  '+duracion	);
        List<Tablacalendario> calendarMes = new List<Tablacalendario>();
        Map <String, Boolean> diasFestivos = new  Map <String, Boolean>();
        
        Date d = System.today();
        if(fecha != 'actual'){
            string[] splitFechaCompleta = fecha.split('T');
            string[] splitFecha = splitFechaCompleta[0].split('-');
            
            d = Date.newInstance(integer.valueof(splitFecha[0]), integer.valueof(splitFecha[1]), integer.valueof(splitFecha[2]));
            system.debug('nueva fecha '+d);
        }
        id id1 = userinfo.getProfileId();
        profile p = [select Name from profile where id = :id1];
       
        boolean esPasado = false;
        if(d < date.today() && p.name == HBT_Constantes.GENERAL_PERFIL_PROFESIONAL){
            esPasado = true;
        }
        system.debug('esPasado '+esPasado);
       // Date hoy = System.today();
        Date monthStart = d.toStartOfMonth();
        system.debug('monthStart '+monthStart);
        Date primerDia = monthStart.toStartOfWeek().addDays(-1);
        Integer numberOfDays = Date.daysInMonth(d.year(), d.month());
        Date lastDayOfMonth = Date.newInstance(d.year(), d.month()+1, 1);
     //   Date primerDiaConsulta  = d; 
       // string userid = UserInfo.getUserId(); 
       // system.debug('primerDia '+primerDia);
       // system.debug('ultimodia '+lastDayOfMonth);
        //Se obtiene el mapa con los festivos del año actual        
        if (primerDia.year() == d.year()){
            diasFestivos = HBT_DateUtil.DiasFestivos(d.year());   
        } else if (primerDia.year() <> d.year() && (primerDia.day()>27) && primerDia.month()>11){
            diasFestivos = HBT_DateUtil.DiasFestivos(d.year());  
        }
        else {           
            diasFestivos = HBT_DateUtil.DiasFestivos(primerDia.year());                     
        }
        
        
        String dom = 'Dom ';
        String lun = 'Lun ';
        String mar = 'Mar ';
        String mie = 'Mie ';
        String jue = 'Jue ';
        String vie = 'Vie ';
        String sab = 'Sab ';
        Integer anno = monthStart.year();
        Integer mes = monthStart.month();
        
        Boolean fesLun = false;
        Boolean fesMar = false;
        Boolean fesMie = false;
        Boolean fesJue = false;
        Boolean fesVie = false;
        Boolean fesSab = false;
        Boolean fesDom = false;
        system.debug('primerDia '+primerDia);
        system.debug('ultimodia '+lastDayOfMonth);
        //se obtiene la dispoibilidad de la sala
        List<HBT_Agenda_sala__c> registrosSalas = new List<HBT_Agenda_sala__c>();
        if(duracion != null && duracion != ''){
            registrosSalas = [SELECT Id, Fecha_inicio__c, Numero_cupos__c, Cupos_ocupados__c, Cupos_disponibles__c 
                              FROM HBT_Agenda_sala__c 
                              where Parametrizacion_disponibilidad__r.Sala__r.id =:sala 
                              and Parametrizacion_disponibilidad__r.Duracion__c  =:duracion and Fecha_inicio__c >= :d 
                              and  Fecha_inicio__c <= :lastDayOfMonth  order by Fecha_inicio__c asc];
        }else{
            registrosSalas = [SELECT Id, Fecha_inicio__c, Numero_cupos__c, Cupos_ocupados__c, Cupos_disponibles__c 
                              FROM HBT_Agenda_sala__c 
                              where Parametrizacion_disponibilidad__r.Sala__r.id =:sala and Fecha_inicio__c >= :d 
                              and  Fecha_inicio__c <= :lastDayOfMonth  order by Fecha_inicio__c asc];
        }
        
                
        system.debug('registrosSalas '+registrosSalas.size());
        
        for (Integer i=0, j=0; i<42; i+=7){
            TablaCalendario ttmp2 = new TablaCalendario();
            //Se consulta si algún día de la semana es festivo
            fesLun = isFestivo (diasFestivos, primerDia.addDays(i+1));
            fesMar = isFestivo (diasFestivos, primerDia.addDays(i+2));
            fesMie = isFestivo (diasFestivos, primerDia.addDays(i+3));
            fesJue = isFestivo (diasFestivos, primerDia.addDays(i+4));
            fesVie = isFestivo (diasFestivos, primerDia.addDays(i+5));
            fesSab = true;
            fesDom = true;
            ttmp2.estadoDom='festivo';
            Integer mesDia = primerDia.addDays(i).month();
            ttmp2.fechadomingo = primerDia.addDays(i);
            if(mes==01 && primerDia.addDays(i).month()==12){
                ttmp2.diaDomingo = ''+primerDia.addDays(i).day();
                ttmp2.estadoDom = 'otroMes';
            } else if(primerDia.addDays(i).month()<mes){
                ttmp2.diaDomingo = ''+primerDia.addDays(i).day();
                ttmp2.estadoDom = 'otroMes';
            } else if (primerDia.addDays(i).month()>mes){
                ttmp2.diaDomingo = ''+primerDia.addDays(i).day();
                ttmp2.estadoDom = 'otroMes';
            } else {
                ttmp2.diaDomingo = ''+primerDia.addDays(i).day();
            }
            if(ttmp2.estadoDom == 'otroMes'){
                ttmp2.estadoDom = 'festivoOtroMes';
            }
            
            ttmp2.festivoDom = true; 
            ttmp2.festivoDomReg = false;
            ttmp2.fechalunes = primerDia.addDays(i+1);
            if(mes==01 && primerDia.addDays(i+1).month()==12){
                ttmp2.diaLunes = ''+primerDia.addDays(i+1).day();
                ttmp2.estadoLun = 'otroMes';
            } else if(primerDia.addDays(i+1).month()<mes){
                ttmp2.diaLunes = ''+primerDia.addDays(i+1).day();
                ttmp2.estadoLun = 'otroMes';
            } else if (primerDia.addDays(i+1).month()>mes){
                ttmp2.diaLunes = ''+primerDia.addDays(i+1).day();
                ttmp2.estadoLun = 'otroMes';
            } else {
                ttmp2.diaLunes = ''+primerDia.addDays(i+1).day();
            }

            ttmp2.adiLunes = 0;
            ttmp2.festivoLunReg = false;
            if(fesLun){
                ttmp2.festivoLun = true; 
                ttmp2.estadoLun = 'festivo';
                if(ttmp2.estadoLun == 'otroMes'){
                    ttmp2.estadoLun = 'festivoOtroMes';
                }
            } else {
                ttmp2.festivoLun = false;  
               // ttmp2.estadoLun = 'normal';
            }
            ttmp2.fechamartes = primerDia.addDays(i+2);
            if(mes==01 && primerDia.addDays(i+1).month()==12){
                ttmp2.diaMartes = ''+primerDia.addDays(i+2).day();
                ttmp2.estadoMar = 'otroMes';
            } else if(primerDia.addDays(i+2).month()<mes){
                ttmp2.diaMartes = ''+primerDia.addDays(i+2).day();
                ttmp2.estadoMar = 'otroMes';
            } else if (primerDia.addDays(i+2).month()>mes){
                ttmp2.diaMartes = ''+primerDia.addDays(i+2).day();
                ttmp2.estadoMar = 'otroMes';
            } else {
                ttmp2.diaMartes = ''+primerDia.addDays(i+2).day();
            }
            ttmp2.adiMartes = 0;
            ttmp2.festivoMarReg = false;
            if(fesMar){
                ttmp2.festivoMar = true;
                ttmp2.estadoMar = 'festivo';
                if(ttmp2.estadoMar == 'otroMes'){
                    ttmp2.estadoMar = 'festivoOtroMes';
                }
            } else {
                ttmp2.festivoMar = false;
               // ttmp2.estadoMar = 'normal';
            }
            ttmp2.fechamiercoles = primerDia.addDays(i+3);
            if(mes==01 && primerDia.addDays(i+3).month()==12){
                ttmp2.diaMiercoles = ''+primerDia.addDays(i+3).day();
                ttmp2.estadoMie = 'otroMes';
            } else if(primerDia.addDays(i+3).month()<mes){
                ttmp2.diaMiercoles = ''+primerDia.addDays(i+3).day();
                ttmp2.estadoMie = 'otroMes';
            } else if (primerDia.addDays(i+3).month()>mes){
                ttmp2.diaMiercoles = ''+primerDia.addDays(i+3).day();
                ttmp2.estadoMie = 'otroMes';
            } else {
                ttmp2.diaMiercoles = ''+primerDia.addDays(i+3).day();
            }
            ttmp2.adiMiercoles = 0;
            ttmp2.festivoMieReg = false;
            if(fesMie){
                ttmp2.festivoMie = true;
                ttmp2.estadoMie = 'festivo';
                if(ttmp2.estadoMie == 'otroMes'){
                    ttmp2.estadoMie = 'festivoOtroMes';
                }
            } else {
                ttmp2.festivoMie = false;
               // ttmp2.estadoMie = 'normal';
            }
            ttmp2.fechajueves = primerDia.addDays(i+4);
            if(mes==01 && primerDia.addDays(i+4).month()==12){
                ttmp2.diaJueves = ''+primerDia.addDays(i+4).day();
                ttmp2.estadoJue = 'otroMes';
            } else if(primerDia.addDays(i+4).month()<mes){
                ttmp2.diaJueves = ''+primerDia.addDays(i+4).day();
                ttmp2.estadoJue = 'otroMes';
            } else if (primerDia.addDays(i+4).month()>mes){
                ttmp2.diaJueves = ''+primerDia.addDays(i+4).day();
                ttmp2.estadoJue = 'otroMes';
            } else {
                ttmp2.diaJueves = ''+primerDia.addDays(i+4).day();
            }
            ttmp2.adiJueves = 0;
            ttmp2.festivoJueReg = false;
            if(fesJue){
                ttmp2.festivoJue = true;
                ttmp2.estadoJue = 'festivo';
                if(ttmp2.estadoJue == 'otroMes'){
                    ttmp2.estadoJue = 'festivoOtroMes';
                }
            } else {
                ttmp2.festivoJue = false;
                //ttmp2.estadoJue = 'normal';
            }
            ttmp2.fechaviernes = primerDia.addDays(i+5);
            if(mes==01 && primerDia.addDays(i+5).month()==12){
                ttmp2.diaViernes = ''+primerDia.addDays(i+5).day();
                ttmp2.estadoVie = 'otroMes';
            } else if(primerDia.addDays(i+5).month()<mes){
                ttmp2.diaViernes = ''+primerDia.addDays(i+5).day();
                ttmp2.estadoVie = 'otroMes';
            } else if (primerDia.addDays(i+5).month()>mes){
                ttmp2.diaViernes = ''+primerDia.addDays(i+5).day();
                ttmp2.estadoVie = 'otroMes';
            } else {
                ttmp2.diaViernes = ''+primerDia.addDays(i+5).day();
            }
            ttmp2.adiViernes = 0;
            ttmp2.festivoVieReg = false;
            if(fesVie){
                ttmp2.festivoVie = true;
                ttmp2.estadoVie = 'festivo';
                if(ttmp2.estadoVie == 'otroMes'){
                    ttmp2.estadoVie = 'festivoOtroMes';
                }
            } else {
                ttmp2.festivoVie = false;
               // ttmp2.estadoVie = 'normal';
            }
            ttmp2.fechasabado = primerDia.addDays(i+6);
            ttmp2.estadoSab = 'festivo';
            if(mes==01 && primerDia.addDays(i+6).month()==12){
                ttmp2.diaSabado = ''+primerDia.addDays(i+6).day();//'*'+
                ttmp2.estadoSab = 'otroMes';
            } else if(primerDia.addDays(i+6).month()<mes){
                ttmp2.diaSabado = ''+primerDia.addDays(i+6).day();
                ttmp2.estadoSab = 'otroMes';
            } else if (primerDia.addDays(i+6).month()>mes){
                ttmp2.diaSabado = ''+primerDia.addDays(i+6).day();//+'*'
                ttmp2.estadoSab = 'otroMes';
            } else {
                ttmp2.diaSabado = ''+primerDia.addDays(i+6).day();
            }
            //   ttmp2.totSabado = totalsabado1;
            ttmp2.festivoSab = true; 
            if(ttmp2.estadoSab == 'otroMes'){
                ttmp2.estadoSab = 'festivoOtroMes';
            }
            ttmp2.festivoSabReg = false;
            ttmp2.concupoLun = false;
            ttmp2.concupoMar = false;
            ttmp2.concupoMie = false;
            ttmp2.concupoJue = false;
            ttmp2.concupoVie = false;
            ttmp2.concupoSab = false;
            ttmp2.concupoDom = false;
            if(!esPasado){
                for(HBT_Agenda_sala__c salaR : registrosSalas){
                    Date fechaConsulta = date.newinstance(salaR.Fecha_inicio__c.year(), salaR.Fecha_inicio__c.month(), salaR.Fecha_inicio__c.day());
                    if(fechaConsulta == ttmp2.fechalunes){
                        ttmp2.totLunes = salaR.Numero_cupos__c;
                        if(salar.Cupos_disponibles__c > 0){
                            ttmp2.estadoLun = 'disponible';
                        }else{
                            ttmp2.estadoLun = 'ocupado';
                        }
                        
                        ttmp2.concupoLun = true;
                        ttmp2.estadoTempLun = ttmp2.estadoLun;
                    }
                    if(fechaConsulta == ttmp2.fechamartes){
                        ttmp2.totMartes = salaR.Numero_cupos__c;
                        if(salar.Cupos_disponibles__c > 0){
                            ttmp2.estadoMar = 'disponible';
                        }else{
                            ttmp2.estadoMar = 'ocupado';
                        }
                        ttmp2.concupoMar = true;
                        ttmp2.estadoTempMar = ttmp2.estadoMar;
                    }
                    if(fechaConsulta == ttmp2.fechamiercoles){
                        ttmp2.totMiercoles = salaR.Numero_cupos__c;
                        if(salar.Cupos_disponibles__c > 0){
                            ttmp2.estadoMie = 'disponible';
                        }else{
                            ttmp2.estadoMie = 'ocupado';
                        }
                        ttmp2.concupoMie = true;
                        ttmp2.estadoTempMie =  ttmp2.estadoMie;
                    }
                    if(fechaConsulta == ttmp2.fechajueves){
                        ttmp2.totJueves = salaR.Numero_cupos__c;
                        if(salar.Cupos_disponibles__c > 0){
                            ttmp2.estadoJue = 'disponible';
                        }else{
                            ttmp2.estadoJue = 'ocupado';
                        }
                        ttmp2.concupoJue = true;
                        ttmp2.estadoTempJue = ttmp2.estadoJue;
                    }
                    if(fechaConsulta == ttmp2.fechaviernes){
                        ttmp2.totViernes = salaR.Numero_cupos__c;
                        if(salar.Cupos_disponibles__c > 0){
                            ttmp2.estadoVie = 'disponible';
                        }else{
                            ttmp2.estadoVie = 'ocupado';
                        }
                        ttmp2.concupoVie = true;
                        ttmp2.estadoTempVie = ttmp2.estadoVie;
                    }
                    if(fechaConsulta == ttmp2.fechasabado){
                        ttmp2.totSabado = salaR.Numero_cupos__c;
                        if(salar.Cupos_disponibles__c > 0){
                            ttmp2.estadoSab = 'disponible';
                        }else{
                            ttmp2.estadoSab = 'ocupado';
                        }
                        ttmp2.concupoSab = true;
                        ttmp2.estadoTempSab = ttmp2.estadoSab;
                    }
                    if(fechaConsulta == ttmp2.fechadomingo){
                        if(salar.Cupos_disponibles__c > 0){
                            ttmp2.estadoDom = 'disponible';
                        }else{
                            ttmp2.estadoDom = 'ocupado';
                        }
                        ttmp2.concupoDom = true;
                        ttmp2.estadoTempDom =   ttmp2.estadoDom;
                    }
                }
            }
            ttmp2.id=i+1;
            system.debug('final '+ttmp2.estadoTempLun);
            calendarMes.add(ttmp2) ; 
        }
        return calendarMes;
            
    }
    //método para determinar si un día es festivo
    public static Boolean isFestivo (map<String, Boolean> diasFestivos, Date diaConsulta){
        string[] datos = diaConsulta.format().split('/');
        String fecha = String.valueOf(datos[1])+'/'+String.valueOf(datos[0])+'/'+String.valueOf(datos[2]);
        Boolean contains = diasFestivos.containsKey(fecha);
        
        if(contains == true){
            return true;
        }
        return false;
    }
    
         /**
* getDetailDataSelected obtiene el detalle de los horarios y cupos de un dia para una sala
@param sala, representa la agenda de la sala a la que corresponde el cupo total
@param fecha, representa la fecha del dia seleccionado
@param examen, representa el id del examen profesional si es el caso de agenda 

*/
    @AuraEnabled(cacheable=true)
    public static Tablacalendario getDetailDataSelected(string fecha, string sala, string examen){
        id id1 = userinfo.getProfileId();
        profile p = [select Name from profile where id = :id1];
        system.debug('examen '+examen);
        Tablacalendario tc= new Tablacalendario();
        system.debug('fecha '+fecha);
        system.debug('sala '+sala);
        if(fecha != null && fecha != ''){
            string[] splitFecha = fecha.split('-');
            
            Datetime d = Datetime.newInstance(integer.valueof(splitFecha[0]), integer.valueof(splitFecha[1]), integer.valueof(splitFecha[2]), 0,0,0);
            system.debug('d '+d);
            Datetime dLast = Datetime.newInstance(integer.valueof(splitFecha[0]), integer.valueof(splitFecha[1]), integer.valueof(splitFecha[2]), 18,59,59);
            system.debug('dLast'+dLast);
            
            
            List<HBT_Agenda_sala__c> registrosSalas = 
                [SELECT Id, Fecha_inicio__c, Numero_cupos__c, Cupos_ocupados__c, Cupos_disponibles__c, hora_inicio__c, hora_fin__c,Parametrizacion_disponibilidad__r.Duracion__c FROM HBT_Agenda_sala__c 
                 where Parametrizacion_disponibilidad__r.Sala__r.id =:sala and Fecha_inicio__c >= :d and Fecha_inicio__c <= :dlast 
                 order by Fecha_inicio__c asc];                
            system.debug('registrosSalas '+registrosSalas.size());
            
            if(registrosSalas.size() > 0){
                List<TablaCalendario> listaCupos = new List<TablaCalendario>();
                List<Detallecalendario> listaDetalle = new List<Detallecalendario>();
                Decimal cupoTotal = 0;
                Decimal cupoDisponible = 0;
                
                if(p.name != HBT_constantes.GENERAL_PERFIL_PROFESIONAL){
                    for(HBT_Agenda_sala__c asala : registrosSalas){
                        Detallecalendario dc = new Detallecalendario();
                        dc.hora = asala.Fecha_inicio__c.format('hh:mm:ss a');
                        dc.cDisponibles = asala.Cupos_disponibles__c;
                        dc.cTotal = asala.Numero_cupos__c;
                        listaDetalle.add(dc);
                        cupoDisponible += dc.cDisponibles;
                        cupoTotal += dc.cTotal;
                    }
                    tc.totLunes = cupoDisponible;
                    tc.totMartes = cupoTotal;
                    tc.estadoLun = registrosSalas.get(0).Parametrizacion_disponibilidad__r.Duracion__c;
                    tc.diaLunes = fecha;
                    tc.listaDetalle = new List<HBT_Agenda_sala__c>();
                    tc.listaDetalle.addALL(registrosSalas);
                }else{
                    List<HBT_Agenda_profesional__c> agendaExistente = 
                        [select id, Agenda_sala__r.id from HBT_Agenda_profesional__c 
                         where Examen_profesional__c  =:examen
                         and Agenda_sala__c  in : registrosSalas];
                    system.debug('agendaExistente '+agendaExistente.size());
                    for(HBT_Agenda_sala__c asala : registrosSalas){
                        Detallecalendario dc = new Detallecalendario();
                        if(asala.Cupos_disponibles__c > 0){
                            TablaCalendario tcc = new TablaCalendario();
                            tcc.idSala = asala.id;
                            tcc.diaLunes = asala.hora_inicio__c;
                            tcc.totLunes = asala.Cupos_disponibles__c;
                             tcc.estadoLun = 'cupo';
                            for(HBT_Agenda_profesional__c ap : agendaExistente){
                                if(ap.Agenda_sala__r.id == asala.id){
                                    system.debug('lo encontre');
                                    tcc.estadoLun = 'seleccionCupo';
                                    break;
                                }
                            }
                           
                            listaCupos.add(tcc);
                        }
                        
                        
                        
                        
                    }
                    tc.listaCupos = new List<TablaCalendario>();
                    tc.listaCupos.addAll(listaCupos);
                    tc.estadoLun = registrosSalas.get(0).Parametrizacion_disponibilidad__r.Duracion__c;
                    tc.diaLunes = fecha;
                    tc.listaDetalle = new List<HBT_Agenda_sala__c>();
                    tc.listaDetalle.addALL(registrosSalas);
                }
            }
            return tc;
        }
          
        return null;
    }

  /**
* guardarCupo permite guardar el cupo seleccionado por el profesional
@param examen, id del examen profesional a relacionar
@param sala, id del la agenda sala a relacionar 
*/
    @AuraEnabled
    public static void guardarCupo(string examen, string sala){
        system.debug('sala: '+sala);
        system.debug('examen: '+examen);
      
        List<HBT_Agenda_profesional__c> agendaExistente = [select id from HBT_Agenda_profesional__c 
                                                           where Examen_profesional__c  =:examen
                                                          ];
        if(agendaExistente.size()>0){
            delete agendaExistente;
        }
        
        HBT_Agenda_profesional__c crearAgenda = new HBT_Agenda_profesional__c();
        crearAgenda.Examen_profesional__c = examen;
        crearAgenda.Agenda_sala__c = sala;
        system.debug('crearAgenda '+crearAgenda);
        insert crearAgenda;
        
        List<HBT_Examen_profesional__c> profesionales = [SELECT Id, profesional__r.email FROM HBT_Examen_profesional__c
                                                            where id = :examen];
        
        system.debug('profesionales '+profesionales);
                List<String> listaEmails = new List<String>(); 
                for(HBT_Examen_profesional__c ep : profesionales){
                    listaEmails.add(ep.profesional__r.email);
                }
                if(listaEmails.size() > 0){
                    HBT_EmailUtil.envioNotificacion(listaEmails, 'Notificar agendamiento examen' , crearAgenda.id);
                    
                }
        
        	
    }
    
    public class Tablacalendario{
        @AuraEnabled public Integer id {get;set;}
        @AuraEnabled public String idSala {get;set;}
        @AuraEnabled public String diaLunes {get;set;}
        @AuraEnabled public String diaMartes {get;set;}
        @AuraEnabled public String diaMiercoles {get;set;}
        @AuraEnabled public String diaJueves {get;set;}
        @AuraEnabled public String diaViernes {get;set;}
        @AuraEnabled public String diaSabado {get;set;}
        @AuraEnabled public String diaDomingo {get;set;}
        @AuraEnabled public String estadoLun {get;set;}
        @AuraEnabled public String estadoMar {get;set;}
        @AuraEnabled public String estadoMie {get;set;}
        @AuraEnabled public String estadoJue {get;set;}
        @AuraEnabled public String estadoVie {get;set;}
        @AuraEnabled public String estadoSab {get;set;}
        @AuraEnabled public String estadoDom {get;set;}
        @AuraEnabled public String estadoTempLun {get;set;}
        @AuraEnabled public String estadoTempMar {get;set;}
        @AuraEnabled public String estadoTempMie {get;set;}
        @AuraEnabled public String estadoTempJue {get;set;}
        @AuraEnabled public String estadoTempVie {get;set;}
        @AuraEnabled public String estadoTempSab {get;set;}
        @AuraEnabled public String estadoTempDom {get;set;}
        @AuraEnabled public Decimal totLunes {get;set;}
        @AuraEnabled public Decimal totMartes {get;set;}
        @AuraEnabled public Decimal totMiercoles {get;set;}
        @AuraEnabled public Decimal totJueves {get;set;}
        @AuraEnabled public Decimal totViernes {get;set;}
        @AuraEnabled public Decimal totSabado {get;set;}
        @AuraEnabled public string totDomingo {get;set;}
        @AuraEnabled public Decimal penLunes {get;set;}
        @AuraEnabled public Decimal penMartes {get;set;}
        @AuraEnabled public Decimal penMiercoles {get;set;}
        @AuraEnabled public Decimal penJueves {get;set;}
        @AuraEnabled public Decimal penViernes {get;set;}
        @AuraEnabled public Decimal adiLunes {get;set;}
        @AuraEnabled public Decimal adiMartes {get;set;}
        @AuraEnabled public Decimal adiMiercoles {get;set;}
        @AuraEnabled public Decimal adiJueves {get;set;}
        @AuraEnabled public Decimal adiViernes {get;set;}
        @AuraEnabled public Date fechalunes {get;set;}
        @AuraEnabled public Date fechamartes {get;set;}
        @AuraEnabled public Date fechamiercoles {get;set;}
        @AuraEnabled public Date fechajueves {get;set;}
        @AuraEnabled public Date fechaviernes {get;set;}
        @AuraEnabled public Date fechasabado {get;set;}
        @AuraEnabled public Date fechadomingo {get;set;}
        @AuraEnabled public Boolean festivoLun {get;set;}
        @AuraEnabled public Boolean festivoMar {get;set;}
        @AuraEnabled public Boolean festivoMie {get;set;}
        @AuraEnabled public Boolean festivoJue {get;set;}
        @AuraEnabled public Boolean festivoVie {get;set;}
        @AuraEnabled public Boolean festivoSab {get;set;}
        @AuraEnabled public Boolean festivoDom {get;set;}
        @AuraEnabled public Boolean festivoLunReg {get;set;}
        @AuraEnabled public Boolean festivoMarReg {get;set;}
        @AuraEnabled public Boolean festivoMieReg {get;set;}
        @AuraEnabled public Boolean festivoJueReg {get;set;}
        @AuraEnabled public Boolean festivoVieReg {get;set;}
        @AuraEnabled public Boolean festivoSabReg {get;set;}
        @AuraEnabled public Boolean festivoDomReg {get;set;}
        @AuraEnabled public String cupoLun {get;set;}
        @AuraEnabled public String cupoMar {get;set;}
        @AuraEnabled public String cupoMie {get;set;}
        @AuraEnabled public String cupoJue {get;set;}
        @AuraEnabled public String cupoVie {get;set;}
        @AuraEnabled public String cupoSab {get;set;}
        @AuraEnabled public String cupoDom {get;set;}
        @AuraEnabled public Boolean concupoLun {get;set;}
        @AuraEnabled public Boolean concupoMar {get;set;}
        @AuraEnabled public Boolean concupoMie {get;set;}
        @AuraEnabled public Boolean concupoJue {get;set;}
        @AuraEnabled public Boolean concupoVie {get;set;}
        @AuraEnabled public Boolean concupoSab {get;set;}
        @AuraEnabled public Boolean concupoDom {get;set;}
        @AuraEnabled public List<HBT_Agenda_sala__c> listaDetalle {get;set;}
        @AuraEnabled public List<TablaCalendario> listaCupos {get;set;}
        public TablaCalendario(){
            diaLunes = '';
            diaMartes = '';
            diaMiercoles = '';
            diaJueves = '';
            diaViernes = '';
            diaSabado = '';
            diaDomingo = '';
            totLunes = 0;
            totMartes = 0;
            totMiercoles = 0;
            totJueves = 0;
            totViernes = 0;
            totSabado = 0;
            penLunes = 0;
            penMartes = 0;
            penMiercoles = 0;
            penJueves = 0;
            penViernes = 0;
            adiLunes = 0;
            adiMartes = 0;
            adiMiercoles = 0;
            adiJueves = 0;
            adiViernes = 0;
            estadoLun = 'normal';
            estadoMar = 'normal';
            estadoMie = 'normal';
            estadoJue = 'normal';
            estadoVie = 'normal';
            estadoTempLun = 'normal';
            estadoTempMar = 'normal';
            estadoTempMie = 'normal';
            estadoTempJue = 'normal';
            estadoTempVie = 'normal';
        }
    }
    
    public class Detallecalendario{
        @AuraEnabled public String hora {get;set;}
        @AuraEnabled public Decimal cDisponibles {get;set;}
        @AuraEnabled public Decimal cTotal {get;set;}
    }
    
}