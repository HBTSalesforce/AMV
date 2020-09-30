/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase que administra el funcionamiento del registro de profesionales.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              01/09/2020
*/
public with sharing class HBT_RegistrarProfesionalController {
    /**
     * getAmvAccountId obtiene el id de la cuenta con nombre AMV
     * @return Id: identificar de la cuenta
     */
    @AuraEnabled(Cacheable=true)
    public static Id getAmvAccountId(){
        Account amvAccount = [SELECT Id, Name FROM Account WHERE Name = 'AMV' LIMIT 1];
        return amvAccount.Id;
    }
 
    /**
     * enableCustomerUser metodo que inicia la creacion del usuario para el profesional
     * @param Id: identificar del profesional creado
     * 
     */
    @AuraEnabled(Cacheable=true)
    public static void enableCustomerUser(String id){
        List<id> usersToEnable = new List<id>();
        usersToEnable.add(id);
        string ip = 'no encontro';
        if(!Test.isRunningTest()) { 
            ip = GetUserIPAddress();
        }
     //   HBT_CreacionUsuarioProfesionalController.enableCustomerUsers(usersToEnable, ip);
    }
    /**
     * getURLTC metodo que obtiene la url para descargar el documento de terminos y condiciones
     * @return string: url del documento de terminos y condiciones a mostrar
     */
    @AuraEnabled(Cacheable=true)
    public static string getURLTC(){
      return System.URL.getSalesforceBaseUrl().toExternalForm() + '/Profesionales/HBT_VerTerminosCondicionesPage?tipo=Hoja de vida';
    }
    
     /**
     * getURLTC metodo que obtiene la ip desde donde se esta realizando el proceso
     * @return string: ip encontrada
     */
    public static String GetUserIPAddress() {
        string ReturnValue = 'No encontro'; 
        if(!Test.isRunningTest()) { 
        ReturnValue = (new PageReference('/apex/HBTViewIPAddress')).
            getContent().toString().
            substringBetween('<ipAddress>', '</ipAddress>');
        }
        system.debug('ReturnValue '+ReturnValue);
        return ReturnValue;
        
    }
    
}