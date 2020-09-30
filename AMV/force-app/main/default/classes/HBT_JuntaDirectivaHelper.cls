public with sharing class HBT_JuntaDirectivaHelper {
    /**
     * Metodo que obtiene la lista de las juntas directivas del usuario logueado
     */
    @AuraEnabled(cacheable=true)
    public static List<HBT_Junta_Directiva__c> getJunta() {
        return [SELECT Id, Entidad__c,Labora_entidad_publica__c
            FROM HBT_Junta_Directiva__c];
    }
}