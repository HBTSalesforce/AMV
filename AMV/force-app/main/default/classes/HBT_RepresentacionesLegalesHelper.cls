public with sharing class HBT_RepresentacionesLegalesHelper {
    @AuraEnabled(cacheable=true)
    public static List<HBT_Representacion_legal__c> getRepresentaciones() {
        return [SELECT Id, Entidad__c, Otra_representacion_legal__c
            FROM HBT_Representacion_legal__c];
    }
}