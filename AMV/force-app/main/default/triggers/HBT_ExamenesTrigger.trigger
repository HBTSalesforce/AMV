/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Trigger que evalua el envio de notificacion de examenes a profesionales relacionados 
con el, una vez sea aprobado el registro
* ─────────────────────────────────────────────────────────────────────────────────────────────────|
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
trigger HBT_ExamenesTrigger  on HBT_Examen__c (after update) {
    HBT_Examen__c examen = trigger.new.get(0);
    List<HBT_Examen__c> examenList= [SELECT Id, fue_Aprobado__c, Enviar_Notificacion__c, Descripcion_notificacion__c, Estado__c 
                                     FROM HBT_Examen__c where id =:examen.id limit 1];
    
    if(examenList.size()>0){
        examen = examenList.get(0);
        if(examen.fue_Aprobado__c){
            if(examen.Enviar_Notificacion__c){
             
                List<HBT_Examen_profesional__c> profesionales = [SELECT Id, profesional__r.email FROM HBT_Examen_profesional__c
                                                            where examen__r.id = :examen.id];
                List<String> listaEmails = new List<String>(); 
                for(HBT_Examen_profesional__c ep : profesionales){
                    listaEmails.add(ep.profesional__r.email);
                }
                if(listaEmails.size() > 0){
                    HBT_EmailUtil.envioNotificacion(listaEmails, 'Notificar cambio examen' , examen.id);
                    
                }
            }
            examen.fue_Aprobado__c = false;
            update examen;
        }
        
        
    }

}