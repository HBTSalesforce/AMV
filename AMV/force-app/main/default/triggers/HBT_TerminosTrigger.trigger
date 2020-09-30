/*
* ───────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Trigger que evalua el envio de notificacion de terminos y condiciones a profesionales/entidades  
relacionados con el, una vez sea aprobado el registro
* ───────────────────────────────────────────────────────────────────────────────────────────────────|
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              22/09/2020
*/
trigger HBT_TerminosTrigger on HBT_Terminos_Condiciones__c (after update) {

    HBT_Terminos_Condiciones__c termino = trigger.new.get(0);
    List<HBT_Terminos_Condiciones__c> terminoList= [SELECT Id, fue_Aprobado__c, Estado__c
                                                    FROM HBT_Terminos_Condiciones__c where id =:termino.id limit 1];
    
     if(terminoList.size()>0){
        termino = terminoList.get(0);
        
        if(termino.fue_Aprobado__c){
            if(termino.estado__c == 'Activo'){
             /*   List<HBT_Antecedente_profesional__c> profesionales = [SELECT Id, profesional__r.email FROM HBT_Antecedente_profesional__c
                                                                      where Antecedente__r.id = :ant.id];
                List<String> listaEmails = new List<String>(); 
                for(HBT_Antecedente_profesional__c ep : profesionales){
                    listaEmails.add(ep.profesional__r.email);
                }
                if(listaEmails.size() > 0){
                    
                    HBT_EmailUtil.envioNotificacion(listaEmails, 'Notificar cambio términos y condiciones' , ant.id);
                }*/
            }
           
            
            termino.fue_Aprobado__c = false;
            update termino;
        }
        
    }
}