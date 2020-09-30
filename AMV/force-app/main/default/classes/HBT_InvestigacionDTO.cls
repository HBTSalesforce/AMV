/**Clase que representa el objeto Investigación como DTO */
public with sharing class HBT_InvestigacionDTO {
    /**Atributo que indica la entidad*/
    public String entidad {get; set;}
    /**Atributo que indica cual entidad*/
    public String cualEntidad {get; set;}
    /**Atributo que indica el estado*/
    public String estado {get; set;}
    /**Atributo que indica el motivo*/
    public String motivo {get; set;}
    /**Atributo que indica la fechas desde*/
    public String fechaDesde {get; set;}
    /**Atributo que indica la fecha hasta*/
    public String fechaHasta {get; set;}                                


    /**Método que se encarga de convertir un objeto investgiación a DTO */
    public void convertirObjetoADTO(HBT_Investigacion__c investigacion){
        this.entidad = investigacion.entidad__c;
        this.cualEntidad = investigacion.cual__c;
        if(investigacion.Motivo_investigacion__c!= null){
            this.motivo = HBT_PicklistUtil.getEtiquetaLista(HBT_Investigacion__c.Motivo_investigacion__c.getDescribe(),investigacion.Motivo_investigacion__c);
        }
        if(investigacion.fecha_desde__c!= null){
            this.fechaDesde = HBT_DateUtil.convertirFechaACadena(investigacion.fecha_desde__c);
        }
        if(investigacion.fecha_hasta__c!= null){
            this.fechaHasta = HBT_DateUtil.convertirFechaACadena(investigacion.fecha_hasta__c);
        }
    }
    
}