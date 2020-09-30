/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase que administra el funcionamiento de gestión de examenes profesional
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              25/09/2020
*/
public class HBT_GestionExamenProfesionalController {
    /**
     * Metodo que obtiene las certificaciones existentes
     */
    @AuraEnabled(cacheable=true)
    public static List<HBT_Certificacion__c> getCertificaciones() {
        return [SELECT Id, Name
            FROM HBT_Certificacion__c];
    }
    /**
     * Metodo que obtiene todos los examenes
     */
    @AuraEnabled(cacheable=true)
    public static List<HBT_Certificacion_examen__c> getExamenesPagar(string idCertificacion) {
        List<HBT_Certificacion_examen__c> relacion=[SELECT Id, Nombre_examen__c,Examen__r.Estado__c, Examen__r.Tarifa__c,Certificacion__c  FROM HBT_Certificacion_examen__c where certificacion__c=:idCertificacion ];
        return relacion;
    }

    
    /**
     * Metodo que obtiene los examenes segun el estado
     * @param estado
     * @return lista con examames consultados
     */
    @AuraEnabled(cacheable=true)
    public static List<DatosExamen> getExamenesPorEstado(string estado) {
        List<DatosExamen> datos = new List<DatosExamen>();
        system.debug('entro '+estado);
        String userName = UserInfo.getUserId();
        List<User> lstUser = [Select ContactId from User where Id = :userName];
         system.debug('entro1 '+lstUser.get(0).contactid);
        List<HBT_Examen_profesional__c> listado = 
            [SELECT Id, Examen__r.name, Examen__r.Canal_presentacion__c, Estado__c, profesional__c, 
            profesional__r.Numero_documento__c, profesional__r.name 
             FROM HBT_Examen_profesional__c 
             where Estado__c = :estado and profesional__c = :lstUser.get(0).contactid];
        
        if(listado.size() >0){
            for(HBT_Examen_profesional__c ex : listado){
                DatosExamen de = new DatosExamen();
                de.id = ex.id;
                de.nombre = ex.Examen__r.name;
                de.canal = ex.Examen__r.Canal_presentacion__c;
                de.estado = ex.estado__c;
                datos.add(de);
            }
        }
        
        system.debug('listado '+datos.size());
        return datos;
    }

    /**
     * Metodo que obtiene los examenes segun el estado
     * @param estado
     * @return lista con examames consultados
     */
    @AuraEnabled(cacheable=true)
    public static List<DatosExamen> getAgendasProfesional(string estado) {
        List<DatosExamen> datos = new List<DatosExamen>();
        system.debug('entro '+estado);
        String userName = UserInfo.getUserId();
        List<User> lstUser = [Select ContactId from User where Id = :userName];
        
        List<HBT_Agenda_profesional__c> listado = 
            [SELECT Id, Examen_profesional__r.Examen__r.name, Examen_profesional__r.Examen__r.Canal_presentacion__c,
            Examen_profesional__r.Estado__c, Examen_profesional__r.profesional__r.Numero_documento__c, Examen_profesional__r.profesional__r.name,
            Ciudad_de_la_sala__c, Agenda_sala__r.Parametrizacion_disponibilidad__r.Sala__r.Name,
            Agenda_sala__r.Parametrizacion_disponibilidad__r.Sala__r.Tipo_sala__c,Agenda_sala__r.Parametrizacion_disponibilidad__r.Sala__r.Url_acceso__c,
            Agenda_sala__r.Parametrizacion_disponibilidad__r.Sala__r.Direccion1__c,Agenda_sala__r.Fecha_inicio__c,
            Agenda_sala__r.hora_inicio__c, Examen_profesional__r.Fecha_vencimiento__c
             FROM HBT_Agenda_profesional__c 
             where Examen_profesional__r.Estado__c = :estado and Examen_profesional__r.profesional__c = :lstUser.get(0).contactid];
        
        if(listado.size() >0){
            for(HBT_Agenda_profesional__c ap : listado){
                DatosExamen de = new DatosExamen();
                de.id = ap.id;
                de.nombre = ap.Examen_profesional__r.Examen__r.name;
                de.canal = ap.Examen_profesional__r.Examen__r.Canal_presentacion__c;
                de.estado = ap.Examen_profesional__r.estado__c;
                de.nombreProfesional = ap.Examen_profesional__r.profesional__r.name;
                de.ciudad = ap.Ciudad_de_la_sala__c;
                if(ap.Agenda_sala__r.Parametrizacion_disponibilidad__r.Sala__r.Tipo_sala__c == 'Virtual'){
                    de.direccion = ap.Agenda_sala__r.Parametrizacion_disponibilidad__r.Sala__r.Url_acceso__c;
                }else{
                    de.direccion = ap.Agenda_sala__r.Parametrizacion_disponibilidad__r.Sala__r.Direccion1__c;
                }
                de.numeroDocumento = ap.Examen_profesional__r.profesional__r.Numero_documento__c;
                de.nombreSala = ap.Agenda_sala__r.Parametrizacion_disponibilidad__r.Sala__r.Name;
                de.fechaPresentacion = ap.Agenda_sala__r.Fecha_inicio__c.date();
                de.hora = ap.Agenda_sala__r.hora_inicio__c;
                de.fechaVencimiento = ap.Examen_profesional__r.Fecha_vencimiento__c;
                datos.add(de);
            }
        }
        
        system.debug('listado '+datos.size());
        return datos;
    }
    
    
     public class DatosExamen{
         @AuraEnabled public String id {get;set;}
         @AuraEnabled public String nombre {get;set;}
         @AuraEnabled public String canal {get;set;}
         @AuraEnabled public String estado {get;set;}
         @AuraEnabled public String nombreProfesional {get;set;}
         @AuraEnabled public String ciudad {get;set;}
         @AuraEnabled public String direccion {get;set;}
         @AuraEnabled public String numeroDocumento {get;set;}
         @AuraEnabled public String nombreSala {get;set;}
         @AuraEnabled public Date fechaPresentacion {get;set;}
         @AuraEnabled public String hora {get;set;}
         @AuraEnabled public Date fechaVencimiento {get;set;}
     }

}