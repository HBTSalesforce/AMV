public with sharing class HBT_SancionesHelper {
   /**
    * Metodo que obtiene la lista de las sanciones registradas por el usuario logueado
    */
    @AuraEnabled(cacheable=true)
    public static List<HBT_Sancion__c> getSanciones() {
        return [SELECT Id, entidad__c
            FROM HBT_Sancion__c];
    }
    /**
     * Metodo que obtiene los links de los archivos relacionados a cada sancion del usuario logueado
     */
    @AuraEnabled(cacheable=true)  
    public static List< String >  getFiles(){ 
       // List<Object> urls= new List<Object>();
        List <String > urls = new List <  String > ();  
        List<Id> idDocumentos= new List<Id>();
        List<Id> idSanciones= new List<Id>();

        for (ContentDocumentLink contenido : [SELECT ContentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM HBT_Sancion__c) and LinkedEntity.Type='HBT_Sancion__c']) {
            idDocumentos.add(contenido.ContentDocumentId);
            idSanciones.add(contenido.LinkedEntityId);
            
        }  
        if(idDocumentos.size()>0){
            List<ContentVersion> doc= [SELECT Id, ContentDocumentId, Title FROM ContentVersion where ContentDocumentId in :idDocumentos] ;    

            if(doc.size()>0){
                for (Integer i = 0; i < doc.size(); i++) {
                    urls.add(System.URL.getSalesforceBaseUrl().toExternalForm()+'/Profesionales/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+doc.get(i).Id+'&operationContext=CHATTER&sancionId= '+idSanciones.get(i)+'&contentId='+doc.get(i).ContentDocumentId);

                }
              //  for (ContentVersion docu : doc) {
              //      urls.add(System.URL.getSalesforceBaseUrl().toExternalForm()+'/Profesionales/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+docu.Id+'&operationContext=CHATTER&contentId='+docu.ContentDocumentId);
             //   }
            }
        }
        return urls;
        } 

    /**
     * Metodo que elimina los archivos relacionados a las sanciones creadas por el usuario logueado
     */
    @AuraEnabled
    public static void deleteFile(String contentDocumentId){ 
        ContentDocument documentoBorrar= new ContentDocument();
        documentoBorrar.Id=contentDocumentId;
        delete documentoBorrar;       
    } 

}