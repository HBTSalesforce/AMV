public with sharing class HBT_InvestigacionesHelper {
    /**
     * Metodo que obtiene las investigaciones de la hoja de vida del usuario logueado
     */
    @AuraEnabled(cacheable=true)
    public static List<HBT_Investigacion__c> getInvestigaciones() {
        return [SELECT Id, Entidad__c
            FROM HBT_Investigacion__c];
    }
    /**
     * Metodo que obtiene los link de los archivos relacionados con las investigaciones
     */
    @AuraEnabled(cacheable=true)  
    public static List< String >  getFiles(){ 
       // List<Object> urls= new List<Object>();
        List <String > urls = new List <  String > ();  
        List<Id> idDocumentos= new List<Id>();
        List<Id> idInvestigaciones= new List<Id>();

        for (ContentDocumentLink contenido : [SELECT ContentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM HBT_Investigacion__c) and LinkedEntity.Type='HBT_Investigacion__c']) {
            idDocumentos.add(contenido.ContentDocumentId);
            idInvestigaciones.add(contenido.LinkedEntityId);
            
        }  
        if(idDocumentos.size()>0){
            List<ContentVersion> doc= [SELECT Id, ContentDocumentId, Title FROM ContentVersion where ContentDocumentId in :idDocumentos] ;    

            if(doc.size()>0){
                for (Integer i = 0; i < doc.size(); i++) {
                    urls.add(System.URL.getSalesforceBaseUrl().toExternalForm()+'/Profesionales/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+doc.get(i).Id+'&operationContext=CHATTER&investigacionId= '+idInvestigaciones.get(i)+'&contentId='+doc.get(i).ContentDocumentId);

                }

            }
        }
        return urls;
        } 
    /**
     * Metodo que elimina los archivos anexados a cada ivestigacion
     */
    @AuraEnabled
    public static void deleteFile(String contentDocumentId){ 
        ContentDocument documentoBorrar= new ContentDocument();
        documentoBorrar.Id=contentDocumentId;
        delete documentoBorrar;       
    } 

}