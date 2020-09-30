@isTest
/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Test que valida el codigo del controlador HBT_Examenestrigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
public class HBT_ExamenesTriggerTest {
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
        contacto.Tipo_documento__c = HBT_Constantes.PROFESIONAL_TIPODOC_CEDULA;
        contacto.Numero_documento__c = '1234567';
        contacto.email = 'correo@correo.com';
        insert contacto;
        
        
        HBT_Examen__c ex = new HBT_Examen__c();
        ex.Codigo_SFC__c = '123';
        ex.Canal_presentacion__c = HBT_Constantes.SALA_TIPOSALA_VIRTUAL;
        ex.Descripcion__c = 'Descripcion';
        ex.Descripcion_notificacion__c = 'texto';
        ex.Detalle_examen__c ='texto';
        ex.Duracion__c = 1;
        ex.Enviar_Notificacion__c = true;
        ex.Estado__c = HBT_Constantes.EXAMEN_ESTADO_PENDIENTE;
        ex.fue_Aprobado__c = true;
        ex.name = 'nombre';
        ex.Numero_preguntas__c = '1';
        ex.Porcentaje_aprobacion__c = '80';
        ex.Tarifa__c = 1000;
        ex.Vigencia__c = 3;
        insert ex;
        
        
        HBT_Examen_profesional__c ep = new HBT_Examen_profesional__c();
        ep.Profesional__c = contacto.id;
        ep.Examen__c = ex.id;
        insert ep;
        
        ex.Duracion__c = 2;
        update ex;
        
        HBT_Examen__c consulta = [select id, fue_Aprobado__c from HBT_Examen__c where id = :ex.id limit 1];
        
        system.assert(!consulta.fue_Aprobado__c);
    }

}