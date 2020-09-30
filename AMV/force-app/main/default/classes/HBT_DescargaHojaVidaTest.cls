/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Test que valida el codigo del controlador HBT_DescargaHojaVidaController
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              16/09/2020
*/
@isTest
public class HBT_DescargaHojaVidaTest {
    
    /*Método test que guarda toda la información de la hoja de vida y la consulta a través del controlador*/
    static testMethod void testConsultarHojaVida(){ 
        
        Account cuenta = new Account();
        cuenta.name = 'AMV';
        cuenta.Tipo_mercado__c = HBT_Constantes.ENTIDAD_TIPOMERCADO_DIVISA;
        cuenta.Divisas__c = true;
        insert cuenta;
        
        RecordType rt = [select id from RecordType where name = :HBT_Constantes.GENERAL_PERFIL_PROFESIONAL  limit 1 ];
        
        Contact contacto = new Contact();
        contacto.RecordTypeId = rt.id;
        contacto.LastName = 'apellido';
        contacto.FirstName = 'nombre';
        contacto.AccountId = cuenta.id;
        contacto.Tipo_documento__c = HBT_Constantes.PROFESIONAL_TIPODOC_CEDULA;
        contacto.Numero_documento__c = '1234567';
        contacto.email = 'correo@correo.com';
        insert contacto;

		HBT_Localizacion__c ciudad = new HBT_Localizacion__c();
		ciudad.name = 'Armenia';
		ciudad.Pais__c = 'Colombia';
		insert ciudad;

		HBT_Institucion_academica__c institucionAcademica = new HBT_Institucion_academica__c();
        institucionAcademica.name = 'Universidad';
        institucionAcademica.Ciudad__c = ciudad.id;
		insert institucionAcademica;
        
        HBT_Carrera__c carrera = new HBT_Carrera__c();
        carrera.name = 'Administración de empresas';
        carrera.institucion_academica__c = institucionAcademica.id;
        insert carrera;
		        
        HBT_Informacion_academica__c informacionAcademica = new HBT_Informacion_academica__c();
        informacionAcademica.Formacion_academica__c = 'Nacional';
        informacionAcademica.Institucion_academica__c = InstitucionAcademica.id;
        informacionAcademica.Carrera__c = carrera.id;
        informacionAcademica.Ciudad__c = ciudad.id;
        informacionAcademica.Fecha_terminacion_grado__c = System.today().addDays(-1);
        informacionAcademica.Profesional__c = contacto.id;
        insert informacionAcademica;
        
        HBT_Sancion__c sancion = new HBT_Sancion__c();
        sancion.entidad__c = 'Bolsa Agropecuaria';
        sancion.Numero_documento_sancion__c = '1212';
        sancion.Profesional__c = contacto.id;
        sancion.Tipo_sancion__c = '343';
        sancion.Valor_multa__c = 2000000;
        insert sancion;
        
        HBT_Investigacion__c investigacion = new HBT_Investigacion__c();
        investigacion.Entidad__c = 'Bolsa Agropecuaria';
        investigacion.Fecha_desde__c = System.today().addDays(-10);
        investigacion.Fecha_hasta__c = System.today().addDays(-5);
        investigacion.Estado__c = '1';
        investigacion.Profesional__c = contacto.id;
        insert investigacion;
        
        ApexPages.currentPage().getParameters().put('id',contacto.id);
        HBT_DescargaHojaVidaController controlador = new HBT_DescargaHojaVidaController();
        
        System.assert(controlador.contacto != null);
		
    }
}