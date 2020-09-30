/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase que permite otener la IP publica del navegador.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              01/09/2020
*/
public class HBTViewIPAddressController {
     public String ipAddress{get; set;}

    /**
     * HBTViewIPAddressController metodo controlador donde se obtiene la ip 
     * 
     */
    public HBTViewIPAddressController(){
        //this will work if no caching is in place or
        //user is logged in via secure URL
        ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'); //.get('True-Client-IP')
         
        //this logic will execute if proxy is in use
        if(String.isEmpty(ipAddress)){
           ipAddress = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');//
        }
    }

}