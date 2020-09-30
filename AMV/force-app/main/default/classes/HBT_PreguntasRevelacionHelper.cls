public with sharing class HBT_PreguntasRevelacionHelper {
    /**
     * Metodo que obtiene la lista de las preguntas revelacion
     */
    @AuraEnabled(cacheable=true)
    public static List<HBT_Pregunta_revelacion__c> getPreguntas() {
        return [SELECT Id,Pregunta_1__c,Pregunta_2__c, Pregunta_3__c, Pregunta_4__c
            FROM HBT_Pregunta_revelacion__c	];
    }
        /**
     * Metodo que obtiene el link del archivo relacionado 
     */
    @AuraEnabled(cacheable=true)  
    public static List< String >  getFiles(){ 
       // List<Object> urls= new List<Object>();
        List <String > urls = new List <  String > ();  
        List<Id> idDocumentos= new List<Id>();
        List<Id> idPregunta= new List<Id>();

        for (ContentDocumentLink contenido : [SELECT ContentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM HBT_Pregunta_revelacion__c ) and LinkedEntity.Type='HBT_Pregunta_revelacion__c']) {
            idDocumentos.add(contenido.ContentDocumentId);
            idPregunta.add(contenido.LinkedEntityId);
            
        }  
        if(idDocumentos.size()>0){
            List<ContentVersion> doc= [SELECT Id, ContentDocumentId, Title FROM ContentVersion where ContentDocumentId in :idDocumentos] ;    

            if(doc.size()>0){
                for (Integer i = 0; i < doc.size(); i++) {
                    urls.add(System.URL.getSalesforceBaseUrl().toExternalForm()+'/Profesionales/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+doc.get(i).Id+'&operationContext=CHATTER&sancionId= '+idPregunta.get(i)+'&contentId='+doc.get(i).ContentDocumentId);

                }

            }
        }
        return urls;
        } 

    /**
     * Metodo que elimina los archivos relacionados a las preguntas creadas por el usuario logueado
     */
    @AuraEnabled
    public static void deleteFile(String contentDocumentId){ 
        ContentDocument documentoBorrar= new ContentDocument();
        documentoBorrar.Id=contentDocumentId;
        delete documentoBorrar;       
    } 
}