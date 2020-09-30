/**Clase que representa el DTO del objeto Sancion */
public with sharing class HBT_SancionDTO {
    /**Atributo que indica la entidad */
    public String entidad {get;set;}
    /**Atributo que indica cual entidad */
    public String cualEntidad {get;set;}
    /**Atributo que indica el tipo de sanción*/
    public String tipoSancion {get;set;} 
    /**Atributo que indica el tipo de documento*/
    public String tipoDocumento {get;set;}  
    /**Atributo que indica el número de documento*/
    public String numeroDocumento {get;set;}  
    /**Atributo que indica el número de documento*/
    public String valorMulta {get;set;}  
    
    /**Método que se encarga de convertir un objeto sanción a DTO */
    public void convertirObjetoADTO(HBT_Sancion__c sancion){
        this.entidad = sancion.entidad__c;
        this.cualEntidad = sancion.cual__c;
        if(sancion.tipo_sancion__c!= null){
            this.tipoSancion = HBT_PicklistUtil.getEtiquetaLista(HBT_Sancion__c.tipo_sancion__c.getDescribe(),sancion.tipo_sancion__c);
        }
        if(sancion.Tipo_documento_sancion__c!= null){
            this.tipoDocumento = HBT_PicklistUtil.getEtiquetaLista(HBT_Sancion__c.Tipo_documento_sancion__c.getDescribe(),sancion.Tipo_documento_sancion__c);
        }
        this.numeroDocumento = sancion.Numero_documento_sancion__c;
        if(sancion.Valor_multa__c!= null){
            this.valorMulta = String.valueOf(sancion.Valor_multa__c);
        }
    }

}