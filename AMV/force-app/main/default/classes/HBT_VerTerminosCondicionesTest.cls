@isTest
/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Test que valida el codigo del controlador HBT_VerTerminosCondicionesController
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
public class HBT_VerTerminosCondicionesTest {
    /*
Metodo que prueba el codigo de todo el controlador
*/
    static testMethod void testGeneralController() 
     { 
         HBT_Terminos_Condiciones__c tc = new HBT_Terminos_Condiciones__c();
         tc.Contenido__c = 'hola';
         tc.Tipo__c = HBT_Constantes.TYC_TIPO_HOJAVIDA;
         insert tc;
         
         apexPages.currentPage().getParameters().put('tipo',HBT_Constantes.TYC_TIPO_HOJAVIDA);
         HBT_VerTerminosCondicionesController controller = new HBT_VerTerminosCondicionesController();
         
         
         System.assert(controller.contenido != '');

	
     }

}