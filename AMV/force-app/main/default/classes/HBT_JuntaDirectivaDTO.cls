/**Clase que representa el DTO de la Junta Directiva*/
public with sharing class HBT_JuntaDirectivaDTO {
    /**Atributo que indica la entidad de la junta directiva */
    public String entidad {get; set;}
    /**Atributo que indica el nit de la entidad de la junta directiva */
    public String nit {get; set;}
    /**Atributo que indica el DV de la entidad de la junta directiva */
    public String dv {get; set;}
    /**Atributo que indica el DV de la entidad de la junta directiva */
    public String calidadMiembro {get; set;}
    /**Atributo que indica la fecha de designación*/
    public String fechaDesignacion {get; set;}
    /**Atributo que indica la fecha desde en que fue elegido */
    public String elegidoDesde{get; set;}
    /**Atributo que indica la fecha hasta que fue elegido */
    public String elegidoHasta{get; set;}

    /**Método encargado de convertir el objeto junta directivo a DTO */
    public void convertirObjetoADTO(HBT_Junta_directiva__c juntaDirectiva){
        this.entidad = juntaDirectiva.entidad__c;
        if(juntaDirectiva.nit__c!= null){
            this.nit = String.valueOf(juntaDirectiva.nit__c);
        }
        this.dv = juntaDirectiva.digito_verificacion__c;
        this.calidadMiembro = juntaDirectiva.calidad_miembro__c;
        if(juntaDirectiva.fecha_designacion__c!= null){
            this.fechaDesignacion = HBT_DateUtil.convertirFechaACadena(juntaDirectiva.fecha_designacion__c);
        }
        if(juntaDirectiva.fecha_designacion__c!=null){
            this.elegidoDesde = HBT_DateUtil.convertirFechaACadena(juntaDirectiva.elegido_desde__c);
        }
        if(juntaDirectiva.elegido_hasta__c!=null){
            this.elegidoHasta = HBT_DateUtil.convertirFechaACadena(juntaDirectiva.elegido_hasta__c);
        }
    }
}