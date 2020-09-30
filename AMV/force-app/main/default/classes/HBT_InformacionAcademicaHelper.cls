public with sharing class HBT_InformacionAcademicaHelper {
    /**
     * Metodo que obtiene toda la informacion academica del usuario logueado
     */
    @AuraEnabled(cacheable=true)
    public static List<HBT_Informacion_academica__c> getInfoAcademica() {
        return [SELECT Id, Nombre_curso__c,	Formacion_academica__c, Nivel_estudio__c, Carrera__r.Name,Institucion_academica__c
            FROM HBT_Informacion_academica__c];
    }
    /**
     * Metodo que obtiene la institucion acdemica generica llamada OTRA
     */
    @AuraEnabled(cacheable=true)
    public static HBT_Institucion_academica__c getInstitucion() {
        return [SELECT Id, Name FROM HBT_Institucion_academica__c WHERE Name='Otro'];

    }


}