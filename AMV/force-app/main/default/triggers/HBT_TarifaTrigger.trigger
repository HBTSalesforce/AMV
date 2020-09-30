/*
* ───────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase Trigger que evalua el envio de notificacion de tarifas promocionales a profesionales/entidades  
relacionados con el, una vez sea aprobado el registro
* ───────────────────────────────────────────────────────────────────────────────────────────────────|
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              22/09/2020
*/
trigger HBT_TarifaTrigger on HBT_Tarifa_Promocional__c (after insert, after update) {
    
    HBT_Tarifa_Promocional__c tarifa = trigger.new.get(0);
    List<HBT_Tarifa_Promocional__c> tarifaList= [SELECT Id, fue_Aprobado__c, Enviar_Notificacion__c, Descripcion_notificacion__c,
                                                 Fecha_inicial__c, Fecha_final__c, estado__c
                                                 FROM HBT_Tarifa_Promocional__c where id =:tarifa.id limit 1];
    
    if(tarifaList.size()>0){
        tarifa = tarifaList.get(0);
        if(!trigger.isbefore){
            if(tarifa.estado__c == 'Activo' && tarifa.fue_Aprobado__c){
                if(tarifa.Enviar_Notificacion__c){
                    
                    /*  List<HBT_Examen_profesional__c> profesionales = [SELECT Id, profesional__r.email FROM HBT_Examen_profesional__c
where examen__r.id = :examen.id];
List<String> listaEmails = new List<String>(); 
for(HBT_Examen_profesional__c ep : profesionales){
listaEmails.add(ep.profesional__r.email);
}*/
                    /*   if(listaEmails.size() > 0){
HBT_EmailUtil.envioNotificacion(listaEmails, 'Notificar cambio tarifa' , tarifa.id);

}
}*/
                    tarifa.fue_Aprobado__c = false;
                    update tarifa;
                }
            }
        }
            system.debug('entre');
            //revisar si se solapan las fechas
            /* List<HBT_Tarifa_Promocional__c> tarifas= [SELECT Id, Fecha_inicial__c, Fecha_final__c
FROM HBT_Tarifa_Promocional__c ];*/
            
            //Atributos para persistir los campos contra los cuales se consultarán los periodos existentes
            Date fechaInicio = null;
            Date fechaFin = null;
            List<String> IDS = new List<String>();
            
            //String para ejecutar el query a la BD
            String query = 'SELECT Id, Fecha_inicial__c, Fecha_final__c FROM HBT_Tarifa_Promocional__c WHERE';
            
            for(HBT_Tarifa_Promocional__c nuevoRegistro : tarifaList){
                if(fechaInicio == null || nuevoRegistro.Fecha_inicial__c < fechaInicio)
                    fechaInicio = nuevoRegistro.Fecha_inicial__c;
                if(fechaFin == null || nuevoRegistro.Fecha_final__c   > fechaFin)
                    fechaFin = nuevoRegistro.Fecha_final__c ;
                if(nuevoRegistro.id<>null)
                    IDS.add(nuevoRegistro.id);
            }
            system.debug('ids '+ids);
            system.debug('fechaInicio '+fechaInicio);
            system.debug('fechaFin '+fechaFin);
            query = query+' ((Fecha_inicial__c >= '+string.valueof(fechaInicio).remove(' 00:00:00') +' and Fecha_inicial__c <= '+string.valueof(fechaFin).remove(' 00:00:00')+
                ') OR (Fecha_final__c  >= '+ string.valueof(fechaInicio).remove(' 00:00:00')+' and Fecha_final__c  <= '+string.valueof(fechaFin).remove(' 00:00:00')+') OR (Fecha_inicial__c >='
                +string.valueof(fechaInicio).remove(' 00:00:00')+' and Fecha_final__c  <= '+ string.valueof(fechaFin).remove(' 00:00:00')+') OR (Fecha_inicial__c < '+ string.valueof(fechaInicio).remove(' 00:00:00') +
                ' and Fecha_final__c  > '+ string.valueof(fechaFin).remove(' 00:00:00')+'))';
            
            if(!IDS.isEmpty()){
                string data = '(';
                for(string a : ids){
                     data += '\''+a+'\',';
                }
                data = data.removeEnd(',');
                data = data+')';
               
                query = query+' AND id NOT IN  '+data;
            }
            system.debug('query '+query);
            //Se ejecuta la consulta armada
            List <HBT_Tarifa_Promocional__c> periodosExistentes = Database.query(query);
            if(!periodosExistentes.isEmpty()){      
                for(HBT_Tarifa_Promocional__c nuevoRegistro :  (List<HBT_Tarifa_Promocional__c>)Trigger.new){
                    for(HBT_Tarifa_Promocional__c periodoExistente : periodosExistentes){
                        //Se valida que no exista un registro previo que se solape con las fechas del nuevo registro
                        if((periodoExistente.Fecha_inicial__c > nuevoRegistro.Fecha_inicial__c && periodoExistente.Fecha_inicial__c < nuevoRegistro.Fecha_final__c)
                           || (periodoExistente.Fecha_final__c > nuevoRegistro.Fecha_inicial__c && periodoExistente.Fecha_final__c < nuevoRegistro.Fecha_final__c)
                           || (periodoExistente.Fecha_inicial__c > nuevoRegistro.Fecha_inicial__c && periodoExistente.Fecha_final__c < nuevoRegistro.Fecha_final__c)
                           || (periodoExistente.Fecha_inicial__c < nuevoRegistro.Fecha_inicial__c && periodoExistente.Fecha_final__c > nuevoRegistro.Fecha_final__c)
                           || (periodoExistente.Fecha_inicial__c == nuevoRegistro.Fecha_inicial__c && periodoExistente.Fecha_final__c == nuevoRegistro.Fecha_final__c)){    
                               nuevoRegistro.addError('Ya existe una tarifa promocional registrada en el rango de fechas '+DateTime.newInstance(tarifa.Fecha_inicial__c.year(), tarifa.Fecha_inicial__c.month(), tarifa.Fecha_inicial__c.day()).format('dd-MM-yyyy')+' al '+DateTime.newInstance(tarifa.Fecha_final__c.year(), tarifa.Fecha_final__c.month(), tarifa.Fecha_final__c.day()).format('dd-MM-yyyy')+' que se solapa con el periodo que se intenta guardar');
                           }   
                    }
                }
            }
        
    }
    
    
}