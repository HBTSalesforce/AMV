@isTest
/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Test que valida el codigo del controlador HBT_DetalleDisponibilidadController
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
public class HBT_DetalleDisponibilidadTest {
    /*
Metodo que prueba el codigo de todo el controlador 
*/
    static testMethod void testGeneralController() 
    { 
        HBT_Sala__c sala = new HBT_Sala__c();
        sala.Tipo_sala__c = HBT_Constantes.SALA_TIPOSALA_VIRTUAL;
        sala.Url_acceso__c = 'www.google.com';
        sala.Estado__c = HBT_Constantes.GENERAL_ESTADO_ACTIVO;
        sala.Numero_Cupos__c = 20;
       // sala.Tipo_via__c = 'Calle';
        insert sala;
        
        HBT_Parametrizacion_disponibilidad__c disp = new HBT_Parametrizacion_disponibilidad__c();
        disp.Sala__c = sala.id;
        disp.Lunes__c = true;
        disp.Duracion__c = '2';
        disp.Fecha_inicio__c = datetime.now();
        disp.Fecha_fin__c = Datetime.now().adddays(5).addHours(2);
        disp.Numero_cupos__c = 10;
        
        insert disp;
        
        HBT_Agenda_sala__c agenda = new HBT_Agenda_sala__c();
        agenda.Fecha_inicio__c = datetime.now();
        agenda.Fecha_fin__c = Datetime.now().addhours(2);
        agenda.Parametrizacion_disponibilidad__c = disp.id;
        agenda.Numero_cupos__c = 10;
        agenda.Origen_cambio__c = HBT_Constantes.SALA_TIPOPARAMETRIZACION_PARAMETRIZACION;
        insert agenda;
        
        HBT_DetalleDisponibilidadController.getPickListSalaValues();
        HBT_DetalleDisponibilidadController.getPickListDuracionValues();
       
        HBT_DetalleDisponibilidadController.getCalendarioList(string.valueof(Date.today()), agenda.id, '2');
        HBT_DetalleDisponibilidadController.Tablacalendario resultado = HBT_DetalleDisponibilidadController.getDetailDataSelected(string.valueof(Date.today()),agenda.id);

        
        System.assert(resultado != null);
    }
}