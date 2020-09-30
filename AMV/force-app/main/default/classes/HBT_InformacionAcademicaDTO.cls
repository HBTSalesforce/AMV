/**Clase DTO de la información académica*/
public with sharing class HBT_InformacionAcademicaDTO {
        /**Atributo que indica el nivel de estudio */
        public String nivelEstudio{get; set;}
        /**Atributo que indicad la institución académica */
        public String institucionAcademica {get;set;}
        /**Atributo que indica l carrera*/
        public String carrera {get; set;}
        /**ATributo que indica el estado del estudio*/
        public String estadoEstudio {get; set;}
        /**Atributo que indica la fecha de grado o terminación */
        public String fechaTerminacion {get; set;}
        /**Atributo que indica la ciudad */
        public String ciudad {get; set;}
        /**Atributo que indica la departamento */
        public String departamento {get; set;}
        /**Atributo que indica la pais */
        public String pais {get; set;}        
        /**Atributo que indica la tipo de curso */
        public String tipoCurso {get; set;}
        /**Atributo que indica el nombre del curso */
        public String nombreCurso {get; set;}

        /**Método encargado de convertir el objeto información académica en DTO */
        public void convertirObjetoADTO(HBT_Informacion_academica__c informacionAcademica){
            this.institucionAcademica = informacionAcademica.Institucion_academica__r.name;
            this.carrera = informacionAcademica.carrera__r.name;
            this.estadoEstudio =HBT_PicklistUtil.getEtiquetaLista(HBT_Informacion_academica__c.Estado_estudio__c.getDescribe(), informacionAcademica.Estado_estudio__c);
            if(informacionAcademica.Fecha_terminacion_grado__c != null){
                this.fechaTerminacion  = HBT_DateUtil.convertirFechaACadena(informacionAcademica.Fecha_terminacion_grado__c);
            }
            this.ciudad = informacionAcademica.ciudad__r.name;
            this.departamento = informacionAcademica.Departamento__c;
            this.pais = HBT_PicklistUtil.getEtiquetaLista(HBT_Informacion_academica__c.Pais__c.getDescribe(),informacionAcademica.Pais__c);
            this.nivelEstudio = HBT_PicklistUtil.getEtiquetaLista(HBT_Informacion_academica__c.Nivel_estudio__c.getDescribe(),informacionAcademica.Nivel_estudio__c);
            this.tipoCurso = HBT_PicklistUtil.getEtiquetaLista(HBT_Informacion_academica__c.Tipo_curso__c.getDescribe(),informacionAcademica.Tipo_curso__c);
            this.nombreCurso = informacionAcademica.nombre_curso__c;
        }
}