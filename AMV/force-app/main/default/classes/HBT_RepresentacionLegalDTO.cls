/**Clase que representa en forma de DTO el objeto de Representación Legal */
public with sharing class HBT_RepresentacionLegalDTO {
     /**Atributo que indica la entidad*/
     public String entidad {get; set;}
     /**Atributo que indica el NIT*/
     public String nit {get; set;}
     /**Atributo que indica el digito de verificación*/
     public String dv {get; set;}
     /**Atributo que indica el clase de representación*/
     public String claseRepresentacion {get; set;}
     /**Atributo que indica la fechas desde*/
     public String fechaDesde {get; set;}
     /**Atributo que indica la fecha hasta*/
     public String fechaHasta {get; set;}
    /**Atributo que indica la fecha designación*/
    public String fechaDesignacion {get; set;}                                    
 
 
     /**Método que se encarga de convertir un objeto representación legal a DTO */
     public void convertirObjetoADTO(HBT_Representacion_legal__c representacionLegal){
         this.entidad = representacionLegal.entidad__c;
         if(representacionLegal.nit__c!= null){
            this.nit = String.valueOf(representacionLegal.nit__c); 
         }
         this.dv = representacionLegal.digito_verificacion__c;
         if(representacionLegal.Clase_representante__c!= null){
             this.claseRepresentacion = HBT_PicklistUtil.getEtiquetaLista(HBT_Representacion_legal__c.Clase_representante__c.getDescribe(),representacionLegal.Clase_representante__c);
         }
         if(representacionLegal.fecha_desde__c!= null){
             this.fechaDesde = HBT_DateUtil.convertirFechaACadena(representacionLegal.fecha_desde__c);
         }
         if(representacionLegal.fecha_hasta__c!= null){
             this.fechaHasta = HBT_DateUtil.convertirFechaACadena(representacionLegal.fecha_hasta__c);
         }
         if(representacionLegal.fecha_designacion__c!= null){
            this.fechaDesignacion = HBT_DateUtil.convertirFechaACadena(representacionLegal.fecha_designacion__c);
        }
     }
}