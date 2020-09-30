@isTest
/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Test que valida el codigo del controlador HBTViewIPAddressController
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
public class HBT_ViewIPAddressTest {
       /*
Metodo que prueba el codigo de todo el controlador
*/
    static testMethod void testGeneralController()
     { 
         HBTViewIPAddressController controller = new HBTViewIPAddressController();
         system.assert(controller.ipAddress != '');
     }

}