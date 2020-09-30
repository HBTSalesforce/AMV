trigger HBT_SalaTrigger on HBT_Sala__c (before Update) {
    
    Map<ID, HBT_Sala__c> lstSala = new  Map<ID, HBT_Sala__c>();
    for (HBT_Sala__c sala : trigger.new) {
        if(sala.estado__c == 'Inactivo'){
        lstSala.put(sala.ID,sala);}
    }
    for(AggregateResult cupos:
    [SELECT Parametrizacion_disponibilidad__r.Sala__c sala, sum(Cupos_ocupados__c)
     FROM HBT_Agenda_sala__c 
     WHERE Fecha_inicio__c >=: system.Now() 
     AND Parametrizacion_disponibilidad__r.Sala__c in:lstSala.KeySet()
     AND Cupos_ocupados__c > 0
     GROUP BY Parametrizacion_disponibilidad__r.Sala__c]){
        HBT_Sala__c  sala = lstSala.get((ID)cupos.get('sala'));
        system.System.debug(sala);
        sala.adderror('No se puede inactivar la sala, tiene exámenes agendados');
    }
      
}