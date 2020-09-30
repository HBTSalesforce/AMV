/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase que contiene la lógica necesaria para el manejo de actividades del mercado de valorse
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              17/09/2020
*/
public with sharing class HBT_ActividadMercadoValoresHelper {
    
        @AuraEnabled(cacheable=true)
        public static List<HBT_Actividad_mercado_valores__c> getActividadMercadoValores() {
            LIst<HBT_Actividad_mercado_valores__c> lista = [SELECT Id, Name, Entidad__c, Producto__c, Profesional__c FROM HBT_Actividad_mercado_valores__c];
            system.debug(lista);
            return lista;
        }
}