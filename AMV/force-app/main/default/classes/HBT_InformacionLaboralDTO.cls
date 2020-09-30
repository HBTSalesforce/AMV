/**Clase DTO con la información laboral */
public with sharing class HBT_InformacionLaboralDTO {
    /**Atributo que indica si laboral actualmente */
    public String laboralActualmente{get; set;}
    /**Atributo que indica la entidad donde labora */
    public String entidad{get; set;}
    /**Atributo que indica tipo de entidad donde labora */
    public String tipoEntidad{get; set;}
    /**Atributo que indica el código de la entidad donde labora */
    public String codigoEntidad{get; set;}
    /**Atributo que indica el nit de la entidad donde labora */
    public String nitEntidad{get; set;}  
    /**Atributo que indica el DV de la entidad donde labora */
    public String dvEntidad{get; set;} 
    /**Atributo que indica país donde labora/ó */
    public String pais{get; set;} 
    /**Atributo que indica departamento donde labora/ó */
    public String departamento{get; set;} 
        /**Atributo que indica ciudad donde labora/ó */
    public String ciudad{get; set;} 
    /**Atributo que indica la dirección donde labora/ó */
    public String direccion{get; set;}
    /**Atributo que indica la telefono donde labora/ó */
    public String telefono{get; set;}
    /**Atributo que indica la correo corporativo donde labora/ó */
    public String correoCorporativo{get; set;}
    /**Atributo que indica la vinculación donde labora/ó */
    public String vinculacion{get; set;}
    /**Atributo que indica el cargo donde labora/ó */
    public String cargo{get; set;}
    /**Atributo que indica las funciones donde labora/ó */
    public String funciones{get; set;}
    /**Atributo que indica las otras funciones donde labora/ó */
    public String otrasFunciones{get; set;}    
    /**Atributo que indica la fecha de ingreso donde labora/ó */
    public String fechaIngreso{get; set;} 
    /**Atributo que indica la fecha de retiro donde labora/ó */
    public String fechaRetiro{get; set;}                    
    /**Atributo que indica la fecha de posesión SFC*/
    public String fechaPosesionSFC{get; set;}      
    /**Atributo que indica la fecha de posesión BVC */
    public String fechaPosesionBVC{get; set;}               
    /**Atributo que indica la fecha de designación */
    public String fechaDesignacion{get; set;}
    /**Atributo que indica la documento de designación */
    public String documentoDesignacion{get; set;}                         
    /**Atributo que indica la documento de designación */
    public String numeroDesignacion{get; set;} 

/**Método encargado de convertir un objeto en el DTO*/    
public void convertirObjetoADTO(HBT_Informacion_Laboral__C informacionLaboral){
    
        this.laboralActualmente = informacionLaboral.Labora_actualmente__c?'Si':'No';
        this.entidad = informacionLaboral.Entidad__r.name;
        this.tipoEntidad = HBT_PicklistUtil.getEtiquetaLista(HBT_Informacion_laboral__c.Tipo_entidad__c.getDescribe(),informacionLaboral.Tipo_entidad__c);
        this.codigoEntidad = HBT_PicklistUtil.getEtiquetaLista(HBT_Informacion_laboral__c.Codigo_entidad__c.getDescribe(),informacionLaboral.Codigo_entidad__c);
        this.nitEntidad = informacionLaboral.nit__c;
        this.dvEntidad = informacionLaboral.Digito_verificacion__c;
        this.pais = informacionLaboral.pais__c;
        this.departamento = informacionLaboral.Departamento__c;
        this.ciudad = informacionLaboral.ciudad__r.name;
        this.direccion = informacionLaboral.direccionL__c;
        this.telefono = informacionLaboral.telefono__c;
        this.correoCorporativo = informacionLaboral.correo_electronico_corporativo__c;
        this.vinculacion = HBT_PicklistUtil.getEtiquetaLista(HBT_Informacion_laboral__c.Vinculacion__c.getDescribe(),informacionLaboral.Vinculacion__c);
        this.cargo = informacionLaboral.Cargo__c;
        
        if(informacionLaboral.Funciones_desempena__c!=null){
        List<String> funciones = informacionLaboral.Funciones_desempena__c.split(';');
        this.funciones='';
        for(String funcion :funciones){
            this.funciones += HBT_PicklistUtil.getEtiquetaLista(HBT_Informacion_laboral__c.Funciones_desempena__c.getDescribe(),funcion) +', ';
        }
        this.funciones =this.funciones.substring(0,this.funciones.length()-2);
    }

        if(informacionLaboral.Otras_Funciones__c!=null && informacionLaboral.Otras_Funciones__c!=''){
            this.otrasFunciones = informacionLaboral.Otras_Funciones__c;
        }
        if(informacionLaboral.Fecha_ingreso__c!=null){
            this.fechaIngreso = HBT_DateUtil.convertirFechaACadena(informacionLaboral.Fecha_ingreso__c);
        }
        if(informacionLaboral.Fecha_retiro__c!=null){
            this.fechaRetiro = HBT_DateUtil.convertirFechaACadena(informacionLaboral.Fecha_retiro__c);
        }
        if(informacionLaboral.Fecha_posesion_SFC__c!=null){
            this.fechaPosesionSFC = HBT_DateUtil.convertirFechaACadena(informacionLaboral.Fecha_posesion_SFC__c);
        }
        if(informacionLaboral.Fecha_posesion_BVC__c!=null){
            this.fechaPosesionBVC = HBT_DateUtil.convertirFechaACadena(informacionLaboral.Fecha_posesion_BVC__c);
        }
        if(informacionLaboral.Fecha_designacion__c!=null){
            this.fechaDesignacion = HBT_DateUtil.convertirFechaACadena(informacionLaboral.Fecha_designacion__c);
        }
        this.documentoDesignacion = informacionLaboral.Documento_designacion__c;
        this.numeroDesignacion = informacionLaboral.Numero_designacion__c;

        
    
}

}