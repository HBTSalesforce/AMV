public with sharing class HBT_InformacionLaboralHelper {
    /**
     * Metodo que obtiene la informacion laboral del usuario logueado
     */
    @AuraEnabled(cacheable=true)
    public static List<HBT_Informacion_laboral__c> getInfoLaboral() {
        return [SELECT Id, 	Cargo__c, Entidad__c,Labora_actualmente__c,	Entidad_publica__c,Complemento__c	
            FROM HBT_Informacion_laboral__c ORDER BY Fecha_ingreso__c DESC];
    }
    /**
     * Metodo que obtiene el id de la Entidad OTRA
     */
    @AuraEnabled(cacheable=true)
    public static Account getEntidadOtra() {
        return [SELECT Id FROM Account where Name='OTRA'];
    }



}