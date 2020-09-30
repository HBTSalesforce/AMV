/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Trigger que valida de la parametrizacion de la disponibilidad de una sala al crear y actualizar
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              01/09/2020
*/
trigger HBT_ParametrizacionDisponibilidadTrigger on HBT_Parametrizacion_disponibilidad__c (after insert, after Update) {
   if(Trigger.isAfter && Trigger.isInsert){
      HBT_Parametrizacion_disponibilidad__c disponiblidad = trigger.New.get(0);
      Boolean existe = HBT_DisponibilidadHandlerTrigger.crearRegistrosAgendaSala(trigger.New.get(0));
      if(!existe){
         disponiblidad.addError('Ya existe una parametrización entre las fechas elegidas');
      }          
   }

   if(Trigger.isAfter && Trigger.isUpdate) {
     HBT_DisponibilidadHandlerTrigger.UpdateParametrizacion(trigger.New.get(0));
    
   }
}