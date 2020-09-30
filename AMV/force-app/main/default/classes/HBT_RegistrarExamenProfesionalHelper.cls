public with sharing class HBT_RegistrarExamenProfesionalHelper {
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
        List<HBT_Certificacion_examen__c> resultado= new List<HBT_Certificacion_examen__c>();
        String userName = UserInfo.getUserId();
        List<User> lstUser = [Select ContactId from User where Id = :userName];
        string idProfesional = lstUser.get(0).ContactId;
        system.debug('idProfesional '+idProfesional);
        
        List<HBT_Examen_profesional__c> listaProfesional= 
            [SELECT Id,Fecha_vencimiento__c, Estado__c,Examen__r.id,  Examen__r.name,Examen__r.Tarifa__c
             FROM HBT_Examen_profesional__c
             WHERE Profesional__c= :idProfesional 
             and (Estado__c = :HBT_Constantes.EXAMEN_ESTADO_REGISTRADO 
                  or Estado__c =:HBT_Constantes.EXAMEN_ESTADO_APROBADO 
                  or Estado__c =:HBT_Constantes.EXAMEN_ESTADO_PAGADO
                  or Estado__c =:HBT_Constantes.EXAMEN_ESTADO_PENDIENTE_PROGRAMAR 
                  or Estado__c =:HBT_Constantes.EXAMEN_ESTADO_PENDIENTE_PRESENTAR 
                  or Estado__c =:HBT_Constantes.EXAMEN_ESTADO_PENDIENTE_PAGAR)  ];
        
        
        list<id> examenes = new list<id>();
        system.debug('listaProfesional '+listaProfesional.size());
        if(listaProfesional.size() > 0){
            for(HBT_Examen_profesional__c ce : listaProfesional){
                
                if(ce.estado__c == HBT_Constantes.EXAMEN_ESTADO_APROBADO && ce.fecha_vencimiento__c != null){
                    Decimal cantidadDias = HBT_ValoresParametrizadosUtil.get(HBT_Constantes.PARAM_EXAMEN_NAME, HBT_Constantes.PARAM_EXAMEN_DIASVENCIMIENTO);
                    Date fechaparametrizada = ce.fecha_vencimiento__c.addDays(-integer.valueof(cantidadDias));
                    if(ce.fecha_vencimiento__c >= fechaparametrizada){
                        examenes.add(ce.Examen__r.id);
                        system.debug('ce.Examen__r.id 1 '+ce.Examen__r.id);
                    }
                }else{
                       if(ce.estado__c != HBT_Constantes.EXAMEN_ESTADO_APROBADO){
                           examenes.add(ce.Examen__r.id);
                           system.debug('ce.Examen__r.id 2 '+ce.Examen__r.id);
                       }
                   }
                    

                 
                
                List<HBT_Certificacion_examen__c> relacion= 
                    [SELECT Id, Nombre_examen__c,Examen__r.Estado__c,Examen__r.id,
                     Examen__r.Name, Examen__r.Tarifa__c,Certificacion__r.Name,Examen__c  FROM HBT_Certificacion_examen__c
                     where  Examen__r.Estado__c=:HBT_Constantes.EXAMEN_ESTADO_ACTIVO
                    and Examen__r.id not in :examenes];
                
                
                 system.debug('listaProfesional '+relacion.size());
                  return relacion;
                
            }
     
        }
        
  
return null;
      
    }
    /**
     * Metodo que asigna profesionales a examenes
     */
    @AuraEnabled
    public static List<HBT_Examen_profesional__c> asignarProfesional(List<HBT_Certificacion_examen__c> lista, string idProfesional) {
        List<HBT_Examen_profesional__c> examenesNuevos= new List<HBT_Examen_profesional__c>();
        for (HBT_Certificacion_examen__c item : lista) {
            HBT_Examen_profesional__c asociado= new HBT_Examen_profesional__c();
             asociado.Estado__c= HBT_Constantes.EXAMEN_ESTADO_REGISTRADO;
             asociado.Name=item.Examen__r.Name;
             asociado.Profesional__c=idProfesional;
             asociado.Examen__c=item.Examen__c;
             examenesNuevos.add(asociado);
        }
        insert examenesNuevos;

        return examenesNuevos;
    }
}