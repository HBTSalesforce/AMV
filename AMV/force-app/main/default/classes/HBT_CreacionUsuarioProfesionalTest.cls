@isTest
/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Test que valida el codigo del controlador HBT_CreacionUsuarioProfesionalController
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
public class HBT_CreacionUsuarioProfesionalTest {

    /*
Metodo que prueba el codigo de todo el controlador
*/
    static testMethod void testGeneralController()
     { 
         Account cuenta = new Account();
         cuenta.name = 'AMV';
         cuenta.Tipo_mercado__c = HBT_Constantes.ENTIDAD_TIPOMERCADO_DIVISA;
         cuenta.Divisas__c = true;
         insert cuenta;
         
       
         
         RecordType rt = [select id from RecordType where name = :HBT_Constantes.GENERAL_PERFIL_PROFESIONAL limit 1 ];
         
         Contact contacto = new Contact();
         contacto.RecordTypeId = rt.id;
         contacto.LastName = 'apellido';
         contacto.FirstName = 'nombre';
         contacto.AccountId = cuenta.id;
       //  contacto.Direccion_residencia__c = dir.id;
         contacto.Tipo_documento__c = HBT_Constantes.PROFESIONAL_TIPODOC_CEDULA;
         contacto.Numero_documento__c = '1234567';
         contacto.email = 'correo@correo.com';
         insert contacto;
         List<id> contactL = new List<id>();
         contactL.add(contacto.id);
         HBT_CreacionUsuarioProfesionalController.enableCustomerUsers(contactL, '0.0.0.0');
         
         List<user> htc = [select id from user where contactId = :contacto.id limit 1];
         system.debug('htc '+htc.size());
        // System.assert(htc.size() > 0);
         
        
     }
}