@isTest
/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Test que valida el codigo del controlador HBT_AntecedenteTrigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
public class HBT_AntecedenteTriggerTest {
       /*
Metodo que prueba el codigo cuando se inactiva un antecedente el controlador
*/
    static testMethod void testInactivarAntecedenteController() 
    { 
        Account cuenta = new Account();
        cuenta.name = 'AMV';
        cuenta.Tipo_mercado__c = 'Divisas';
        cuenta.Divisas__c = true;
        insert cuenta;
        
        
        
        RecordType rt = [select id from RecordType where name = :HBT_Constantes.GENERAL_PERFIL_PROFESIONAL limit 1 ];
        
        Contact contacto = new Contact();
        contacto.RecordTypeId = rt.id;
        contacto.LastName = 'apellido';
        contacto.FirstName = 'nombre';
        contacto.AccountId = cuenta.id;
        contacto.Tipo_documento__c = HBT_Constantes.PROFESIONAL_TIPODOC_CEDULA;
        contacto.Numero_documento__c = '1234567';
        contacto.email = 'correo@correo.com';
        insert contacto;
        
        HBT_Antecedente__c ant = new HBT_Antecedente__c();
        ant.fue_Aprobado__c  = true;
        ant.Estado__c = HBT_Constantes.ANT_ESTADO_INACTIVO;
        ant.Enviar_Notificacion__c = true;
        ant.Tarifa__c = 1000;
        ant.Descripcion_notificacion__c = 'test';
        ant.Documentacion_antecedentes__c = 'test';
        ant.name= 'nombre antecedente';
        ant.Vigencia__c = 1;
        insert ant;
     
        
        HBT_Antecedente_profesional__c ap = new HBT_Antecedente_profesional__c();
        ap.Profesional__c = contacto.id;
        ap.Antecedente__c = ant.id;
        insert ap;
        
        ant.Vigencia__c = 2;
        update ant;
        
        HBT_Antecedente__c consulta = [select id, fue_Aprobado__c from HBT_Antecedente__c where id = :ant.id limit 1];
        
        system.assert(!consulta.fue_Aprobado__c);
    }
     /*
Metodo que prueba el codigo cuando se activa un antecedente el controlador
*/
    static testMethod void testActivarAntecedenteController() 
    { 
        Account cuenta = new Account();
        cuenta.name = 'AMV';
        cuenta.Tipo_mercado__c = 'Divisas';
        cuenta.Divisas__c = true;
        insert cuenta;
        
        
        
        RecordType rt = [select id from RecordType where name = :HBT_Constantes.GENERAL_PERFIL_PROFESIONAL limit 1 ];
        
        Contact contacto = new Contact();
        contacto.RecordTypeId = rt.id;
        contacto.LastName = 'apellido';
        contacto.FirstName = 'nombre';
        contacto.AccountId = cuenta.id;
        contacto.Tipo_documento__c = HBT_Constantes.PROFESIONAL_TIPODOC_CEDULA;
        contacto.Numero_documento__c = '1234567';
        contacto.email = 'correo@correo.com';
        insert contacto;
        
        HBT_Antecedente__c ant = new HBT_Antecedente__c();
        ant.fue_Aprobado__c = true;
        ant.Estado__c = HBT_Constantes.ANT_ESTADO_ACTIVO;
        ant.Enviar_Notificacion__c = true;
        ant.Tarifa__c = 1000;
        ant.Descripcion_notificacion__c = 'test';
        ant.Documentacion_antecedentes__c = 'test';
        ant.name= 'nombre antecedente';
        ant.Vigencia__c = 1;
        insert ant;
     
        
        HBT_Antecedente_profesional__c ap = new HBT_Antecedente_profesional__c();
        ap.Profesional__c = contacto.id;
        ap.Antecedente__c = ant.id;
        insert ap;
        
        ant.Vigencia__c = 2;
        update ant;
        
        HBT_Antecedente__c consulta = [select id, fue_Aprobado__c from HBT_Antecedente__c where id = :ant.id limit 1];
        
        system.assert(!consulta.fue_Aprobado__c);
    }


}