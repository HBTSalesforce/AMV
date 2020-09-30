public with sharing class HBT_InformacionProfesionalHelper {
  /**
   * Metodo que trae la informacion del contacto logueado
   */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getAvanceContacto() {
        return [SELECT Id,Informacion_actividad_mercado_completa__c, Cantidad_investigaciones__c,
        Informacion_junta_directiva_completa__c, Utilima_pestana_modificada__c,Cantidad_sanciones__c,
        Informacion_laboral_completa__c,Informacion_academica_completa__c,Avance__c,Informacion_representacion_completa__c,
         Name,Informacion_representacion_legal__c,Informacion_laboral__c,Informacion_investigacion_completa__c,
         Informacion_academica__c,Ciudad_nacimiento__c,Informacion_Junta_Directiva__c,
         Informacion_Investigacion__c,Informacion_sancion_completa__c,Informacion_Sancion__c   FROM Contact limit 1];
    }
    /**
     * Metodo que genera el link para descargar la hoja de vida
     */
    @AuraEnabled(Cacheable=true)
    public static string getURLHojaVida(string idContacto){       
      return System.URL.getSalesforceBaseUrl().toExternalForm() + '/Profesionales/HBT_DescargaHojaVidaPage?id='+idContacto;
    }
/**
 * Metodo que obtiene la foto de perfil del usuario logueado
 */
    @AuraEnabled(cacheable=true) 
    public static List<user> getFoto(string recordId){
        return [SELECT Id, Name, SmallPhotoUrl FROM User where ContactId=:recordId];
    }
    /**
     * Metodo que actualiza los no aplica de la hoja de vida del usuario logueado
     */
    @AuraEnabled
    public static Contact actualizarAplica(Boolean campoAplica, string tipo){
       Contact contacto= [SELECT Id FROM Contact limit 1 ];
       if(tipo.equalsIgnoreCase('academica')){
         contacto.Informacion_academica__c= campoAplica;
         update contacto;
         return contacto;
       }else if(tipo.equalsIgnoreCase('laboral')){
        contacto.Informacion_laboral__c= campoAplica;
        update contacto;
        return contacto;
       }else if(tipo.equalsIgnoreCase('sancion')){
        contacto.Informacion_Sancion__c= campoAplica;
        update contacto;
        return contacto;
       }else if(tipo.equalsIgnoreCase('investigacion')){
        contacto.Informacion_Investigacion__c= campoAplica;
        update contacto;
        return contacto;
       }else if(tipo.equalsIgnoreCase('representaciones')){
        contacto.Informacion_representacion_legal__c= campoAplica;
        update contacto;
        return contacto;
       }else if(tipo.equalsIgnoreCase('juntas')){
        contacto.Informacion_Junta_Directiva__c= campoAplica;
        update contacto;
        return contacto;
       }else if(tipo.equalsIgnoreCase('mercadoValores')){
        contacto.Informacion_actividad_mercado_valores__c= campoAplica;
        update contacto;
        return contacto;
       }
       return contacto;
      }
      /**
       * Metodo que actualiza el campo de ultima pestania modificada
       */
      @AuraEnabled
      public static Contact actualizarPestania(string pestania){
        Contact contacto= [SELECT Id FROM Contact limit 1 ];
          contacto.Utilima_pestana_modificada__c=pestania;
          update contacto;
        return contacto; 
      }



}