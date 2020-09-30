/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase de validación de la parametrizacion de la disponibilidad de una sala al crear y actualizar
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada: 10/09/2020
*/
public  class HBT_DisponibilidadHandlerTrigger {
   /*este metodo es para crear una disponibilidad de parametrizacion de una sala.*/
   public  static Boolean crearRegistrosAgendaSala(HBT_Parametrizacion_disponibilidad__c disponibilidad){
      Datetime fechaInicial = disponibilidad.Fecha_inicio__c;
      Datetime fechaFinal = disponibilidad.Fecha_fin__c;
      Integer hours = disponibilidad.Fecha_inicio__c.hour(), minutes = disponibilidad.Fecha_inicio__c.minute(), seconds = disponibilidad.Fecha_inicio__c.second();
      Integer hoursF = disponibilidad.Fecha_fin__c.hour(), minutesF = disponibilidad.Fecha_fin__c.minute(), secondsF = disponibilidad.Fecha_fin__c.second();
      Integer duracion = integer.valueof(disponibilidad.duracion__c); 
      List<String> diasSeleccionados = DiasSeleccionados(disponibilidad);
      List<HBT_Agenda_sala__c> agendas = new List<HBT_Agenda_sala__c>();                
      while (fechaInicial <= fechaFinal) {
            string dia =  HBT_DateUtil.calcularDia(fechaInicial.date());
            if(diasSeleccionados.contains(dia)){                                  
               for(integer i = hours; i < hoursF; i+=duracion){ 
                  Datetime fechaInicialInsertada = Datetime.newInstance(integer.valueof(fechaInicial.year()), integer.valueof(fechaInicial.month()), integer.valueof(fechaInicial.day()), i,minutes,seconds);
                  Datetime fechaFinalIsertada = Datetime.newInstance(integer.valueof(fechaInicial.year()), integer.valueof(fechaInicial.month()), integer.valueof(fechaInicial.day()), (i+duracion),minutes,seconds);
                   agendas.add(new HBT_Agenda_sala__c (
                     Fecha_inicio__c = fechaInicialInsertada,
                     Fecha_fin__c = fechaFinalIsertada,
                     Numero_cupos__c = disponibilidad.Numero_cupos__c,
                     Origen_cambio__c = 'Parametrización de disponibilidad',
                     Parametrizacion_disponibilidad__c = disponibilidad.Id
                     ));
               }
            }
           fechaInicial =  fechaInicial.addDays(1);
         }
         Boolean agendar = ValidarDisponibilidad(disponibilidad);
         if(agendar){
             insert agendas; 
             return true;             
         }else{
            return false;
         }   
   }

   /* Metodo que valida antes de crear la parametrizacion de una disponibilidad  */
   public static Boolean validarExamenAgendado(HBT_Parametrizacion_disponibilidad__c disponibilidad){
      List<HBT_Agenda_sala__c> agendasAntigua = new List<HBT_Agenda_sala__c>(); 
      agendasAntigua = [select Fecha_inicio__c,Fecha_fin__c,Cupos_ocupados__c,Name
      from HBT_Agenda_sala__c 
      where Parametrizacion_disponibilidad__c =: disponibilidad.Id
      and Cupos_ocupados__c > 0
      order by Fecha_inicio__c ASC];      
      if(agendasAntigua.size() > 0){
         disponibilidad.adderror('No se puede modificar la disponiblidad, ya tiene exámanes programados');
         return false ;
      }
      return true;      
   }

 /* Metodo que valida una parametrización de disponibilidad cuando se va actualizar. */
   public static Boolean ValidarDisponibilidad(HBT_Parametrizacion_disponibilidad__c disponibilidadNueva){
      List<HBT_Parametrizacion_disponibilidad__c> parametrizaciones = new List<HBT_Parametrizacion_disponibilidad__c>();
      Datetime fechaInicio = disponibilidadNueva.Fecha_inicio__c;
      Datetime fechaFin = disponibilidadNueva.Fecha_fin__c;
      List<String> LstDiasSeleccionados = DiasSeleccionados(disponibilidadNueva);
      //consulto parametrizacion
      String fechaInicial  = fechaInicio.formatGMT('yyyy-MM-dd');
      String fechaFinal = fechaFin.formatGMT('yyyy-MM-dd');   
      String query = 'SELECT Fecha_inicio__c, Fecha_fin__c, Id, Name ' +
      'FROM HBT_Parametrizacion_disponibilidad__c ' +
      'WHERE (Id !=\''+disponibilidadNueva.Id+'\' AND sala__c =\''+ disponibilidadNueva.sala__c+'\') AND ((DAY_ONLY(Fecha_inicio__c) <='+ fechaInicial+' and DAY_ONLY(Fecha_fin__c) >='+ fechaInicial+') OR (DAY_ONLY(Fecha_inicio__c)<='+ fechaFinal+' and DAY_ONLY(Fecha_fin__c) >='+ fechaFinal+' ) OR (DAY_ONLY(Fecha_inicio__c) >='+ fechaInicial+' and DAY_ONLY(Fecha_inicio__c) <='+ fechaFinal+') OR (DAY_ONLY(Fecha_fin__c) >='+ fechaInicial+' and DAY_ONLY(Fecha_fin__c) <='+ fechaFinal+')) AND(';
      IF(LstDiasSeleccionados.contains('Domingo')){
         query += ' Domingo__c = true OR' ; 
      }
      IF(LstDiasSeleccionados.contains('Lunes')){
         query += ' Lunes__c = true OR' ; 
      }
      IF(LstDiasSeleccionados.contains('Martes')){
         query += ' Martes__c = true OR' ; 
      }
      IF(LstDiasSeleccionados.contains('Miércoles')){
         query += ' Miercoles__c = true OR' ; 
      }
      IF(LstDiasSeleccionados.contains('Jueves')){
         query += ' Jueves__c = true OR' ; 
      }
      IF(LstDiasSeleccionados.contains('Viernes')){
         query += ' Viernes__c = true OR' ; 
      }
      IF(LstDiasSeleccionados.contains('Sábado')){
         query += ' Sabado__c = true OR' ; 
      }
      query = query.SubString(0,query.Length()-2);
      query += ')';
      parametrizaciones = database.query(query);
      //consulta an
      for(HBT_Parametrizacion_disponibilidad__c parametrizacion: parametrizaciones){
         time horaInicialParametrizacion = parametrizacion.Fecha_inicio__c.time();
         time horaFinalParametrizacion = parametrizacion.Fecha_fin__c.time();
         time horaInicial = disponibilidadNueva.Fecha_inicio__c.time();
         time horaFinal = disponibilidadNueva.Fecha_fin__c.time();
         if((horaInicialParametrizacion < horaInicial && horaFinalParametrizacion > horaInicial)
         || (horaInicialParametrizacion < horaFinal && horaFinalParametrizacion > horaFinal )
         || (horaInicialParametrizacion > horaInicial && horaInicialParametrizacion < horaFinal)
         || (horaFinalParametrizacion > horaInicial && horaFinalParametrizacion < horaFinal)
         || (horaInicialParametrizacion == horaInicial && horaFinalParametrizacion == horaFinal) ){
            disponibilidadNueva.adderror('No se puede modificar la disponiblidad, ya existe una programación para la fechas seleccionada');
            return false;
         }
      }      
      return  true;            
   }
 /*Metodo para actualizar una disponibilidad  */
   public static void UpdateParametrizacion(HBT_Parametrizacion_disponibilidad__c disponibilidad){
      Boolean respuesta = false;
      respuesta = validarExamenAgendado(disponibilidad);
      if(respuesta){
         respuesta =  ValidarDisponibilidad(disponibilidad);       
         if(respuesta){
            List<HBT_Agenda_sala__c> agendas = new List<HBT_Agenda_sala__c>(); 
            Datetime fechaInicial = disponibilidad.Fecha_inicio__c;
            Datetime fechaFinal = disponibilidad.Fecha_fin__c;
            Integer hours = disponibilidad.Fecha_inicio__c.hour(), minutes = disponibilidad.Fecha_inicio__c.minute(), seconds = disponibilidad.Fecha_inicio__c.second();
            Integer hoursF = disponibilidad.Fecha_fin__c.hour(), minutesF = disponibilidad.Fecha_fin__c.minute(), secondsF = disponibilidad.Fecha_fin__c.second();
            Integer duracion = integer.valueof(disponibilidad.duracion__c); 
            List<String> diasSeleccionados = DiasSeleccionados(disponibilidad);
            //actualizo el objeto de sala.
            while (fechaInicial <= fechaFinal) {
               string dia =  HBT_DateUtil.calcularDia(fechaInicial.date());
               if(diasSeleccionados.contains(dia)){                                  
                  for(integer i = hours; i < hoursF; i+=duracion){ 
                     Datetime fechaInicialInsertada = Datetime.newInstance(integer.valueof(fechaInicial.year()), integer.valueof(fechaInicial.month()), integer.valueof(fechaInicial.day()), i,minutes,seconds);
                     Datetime fechaFinalIsertada = Datetime.newInstance(integer.valueof(fechaInicial.year()), integer.valueof(fechaInicial.month()), integer.valueof(fechaInicial.day()), (i+duracion),minutes,seconds);
                     agendas.add(new HBT_Agenda_sala__c (
                        Fecha_inicio__c = fechaInicialInsertada,
                        Fecha_fin__c = fechaFinalIsertada,
                        Numero_cupos__c = disponibilidad.Numero_cupos__c,
                        Origen_cambio__c = 'Parametrización de disponibilidad',
                        Parametrizacion_disponibilidad__c = disponibilidad.Id
                        ));                     
                     }
               }
               fechaInicial =  fechaInicial.addDays(1);
            }
           //actualizo el objeto agendas.
            HBT_Agenda_sala__c[] agendaDelete = [SELECT Id, Name FROM HBT_Agenda_sala__c 
                                                WHERE Parametrizacion_disponibilidad__c =: disponibilidad.Id]; 
            delete agendaDelete;
            insert agendas;
         }
      }       
   }
   
   /* Metodo para cacular los dias seleccionados por el usuario*/
   public static List<String> DiasSeleccionados(HBT_Parametrizacion_disponibilidad__c disponibilidad){
      List<String> diasSeleccionados = new List<String>{};
      if(disponibilidad.Lunes__c){
         diasSeleccionados.add('Lunes');
      }
      if(disponibilidad.Martes__c){
         diasSeleccionados.add('Martes');
      }
      if(disponibilidad.Miercoles__c){
         diasSeleccionados.add('Miércoles');
      }
      if(disponibilidad.Jueves__c ){
         diasSeleccionados.add('Jueves');
      }
      if(disponibilidad.Viernes__c){
         diasSeleccionados.add('Viernes');
      }
      if(disponibilidad.Sabado__c){
         diasSeleccionados.add('Sábado');
      }
      if(disponibilidad.Domingo__c){
         diasSeleccionados.add('Domingo');
      }
      return diasSeleccionados;
   }
   
}