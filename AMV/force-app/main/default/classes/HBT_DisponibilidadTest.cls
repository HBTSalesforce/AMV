@isTest
/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Test que valida el codigo del controlador HBT_DisponibilidadHandler
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              16/09/2020
*/
public  class HBT_DisponibilidadTest {
    /* Metodo que crear una disponibilidad*/
    static testMethod void testInsertDisponibilidad() 
    { 
         HBT_Sala__c sala = new HBT_Sala__c();
        sala.Tipo_sala__c = HBT_Constantes.SALA_TIPOSALA_VIRTUAL;
        sala.Url_acceso__c = 'www.google.com';
        sala.Estado__c = HBT_Constantes.GENERAL_ESTADO_ACTIVO;
        sala.Numero_Cupos__c = 20;
        
        insert sala;

        HBT_Parametrizacion_disponibilidad__c disp = new HBT_Parametrizacion_disponibilidad__c();
        disp.Sala__c = sala.id;
        disp.Lunes__c = true;
        disp.Duracion__c = '2';
        disp.Fecha_inicio__c = datetime.now();
        disp.Fecha_fin__c = Datetime.now().adddays(5).addHours(4);
        disp.Numero_cupos__c = 20;
                
        insert disp;
            
    }
    /*Metodo de actualizar una disponibilidad*/
    static testMethod void testUpdateDisponibilidad(){
        
        HBT_Sala__c sala = new HBT_Sala__c();
        sala.Tipo_sala__c = HBT_Constantes.SALA_TIPOSALA_VIRTUAL;
        sala.Url_acceso__c = 'www.google.com';
        sala.Estado__c = HBT_Constantes.GENERAL_ESTADO_ACTIVO;
        sala.Numero_Cupos__c = 10;
        insert sala;

        HBT_Parametrizacion_disponibilidad__c disp = new HBT_Parametrizacion_disponibilidad__c();
        disp.Sala__c = sala.id;
        disp.Lunes__c = true;
        disp.Martes__c = true;
        disp.Duracion__c = '1';
        disp.Fecha_inicio__c = datetime.now();
        disp.Fecha_fin__c = Datetime.now().adddays(4).addHours(2);
        disp.Numero_cupos__c = 10;
                
        insert disp;  
        disp.Fecha_fin__c = Datetime.now().adddays(4).addHours(2);
        disp.Jueves__c = true;
        disp.Sabado__c = true;
        disp.Martes__c = false;
        
        update disp;
    }

}