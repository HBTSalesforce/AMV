/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Trigger que evalua el envio de notificacion de antecedentes a profesionales relacionados 
con el, una vez sea aprobado o rechado el registro
* ─────────────────────────────────────────────────────────────────────────────────────────────────|
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
trigger HBT_AntecedentesTrigger  on HBT_Antecedente__c (after update) {
    HBT_Antecedente__c ant = trigger.new.get(0);
    List<HBT_Antecedente__c> antList= [SELECT Id, fue_Aprobado__c, Estado__c,Enviar_Notificacion__c
                                       FROM HBT_Antecedente__c where id =:ant.id limit 1];
    
    if(antList.size()>0){
        ant = antList.get(0);
        
        if(ant.fue_Aprobado__c){
            if(ant.estado__c == 'Activo' && ant.Enviar_Notificacion__c){
                List<HBT_Antecedente_profesional__c> profesionales = [SELECT Id, profesional__r.email FROM HBT_Antecedente_profesional__c
                                                                      where Antecedente__r.id = :ant.id];
                List<String> listaEmails = new List<String>(); 
                for(HBT_Antecedente_profesional__c ep : profesionales){
                    listaEmails.add(ep.profesional__r.email);
                }
                if(listaEmails.size() > 0){
                    
                    HBT_EmailUtil.envioNotificacion(listaEmails, 'Notificar cambio antecedente' , ant.id);
                }
            }
            if(ant.estado__c == 'Inactivo'){
                List<HBT_Antecedente_profesional__c> profesionales = [SELECT Id, profesional__r.email FROM HBT_Antecedente_profesional__c
                                                                      where Antecedente__r.id = :ant.id];
                List<String> listaEmails = new List<String>(); 
                for(HBT_Antecedente_profesional__c ep : profesionales){
                    listaEmails.add(ep.profesional__r.email);
                }
                if(listaEmails.size() > 0){
                    HBT_EmailUtil.envioNotificacion(listaEmails, 'Notificar inactivacion antecedente' , ant.id);
                }
            }
            
            ant.fue_Aprobado__c = false;
            update ant;
        }
        
    }
    
}