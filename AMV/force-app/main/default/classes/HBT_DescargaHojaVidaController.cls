/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase que se encarga de realizar la lógica para consultar la hoja de vida del profesional
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              20/08/2020
*/
public with sharing class HBT_DescargaHojaVidaController {
    
    /*Contacto para ser mostrado en el PDF*/
    public Contact contacto {get; set;}
    public ContactoDTO contactoDTO {get; set;}
    public List<HBT_InformacionAcademicaDTO> informacionesAcademica {get;set;}
    public List<HBT_InformacionLaboralDTO>  informacionLaborales {get;set;}
    public List<HBT_JuntaDirectivaDTO>  juntaDirectivas {get;set;}
    public List<HBT_SancionDTO>  sanciones {get;set;}
    public List<HBT_InvestigacionDTO>  investigaciones {get;set;}
    public List<HBT_RepresentacionLegalDTO>  representaciones {get;set;}
    
    /*Método constructor*/
    public HBT_DescargaHojaVidaController(){
        string contactoid = apexPages.currentPage().getParameters().get('id');
        if(contactoId<> null && contactoID<> ''){
            contacto = [SELECT Id, Name, Tipo_documento__c, Numero_documento__c,  Genero__c,  Nivel_escolaridad__c,DireccionR__c,DireccionN__c,
                        Pais_nacimiento__c,Departamento_nacimiento__c,Ciudad_nacimiento__r.name,birthdate, Pais_nacionalidad__c,Estado_civil__c,
                        Departamento_residencia__c,Ciudad_residencia__r.name,phone,mobilePhone,email,
                        Departamento_notificacion__c,Ciudad_notificacion__r.name, OtherPhone, Celular_notificacion__c,npe01__WorkEmail__c 
                        FROM Contact WHERE id = :contactoid  WITH SECURITY_ENFORCED];
            
            /**Se crea contacto DTO para realizar el formato correspondiente a campos tipo picklist y date */
            contactoDTO = new ContactoDTO();
            contactoDTO.tipoDocumento = HBT_PicklistUtil.getEtiquetaLista(Contact.Tipo_documento__c.getDescribe(), contacto.Tipo_documento__c);
            contactoDTO.genero = HBT_PicklistUtil.getEtiquetaLista(Contact.Genero__c.getDescribe(), contacto.Genero__c);
            contactoDTO.nivelEscolaridad = HBT_PicklistUtil.getEtiquetaLista(Contact.Nivel_escolaridad__c.getDescribe(), contacto.Nivel_escolaridad__c);
            contactoDTO.fechaNacimiento = HBT_DateUtil.convertirFechaACadena(contacto.birthdate);
            contactoDTO.paisNacionalidad = HBT_PicklistUtil.getEtiquetaLista(Contact.Pais_nacionalidad__c.getDescribe(),contacto.Pais_nacionalidad__c);
            contactoDTO.estadoCivil = HBT_PicklistUtil.getEtiquetaLista(Contact.Estado_civil__c.getDescribe(),contacto.Estado_civil__c);
            
            /**Llamado a los método de la información relacionada */
            consultarInforamcionAcademica();
            consultarInformacionLaboral();
            consultarJuntaDirectiva();
            consultarSanciones();
            consultarInvestigaciones();
            consultarRepresentacionLegal();
        }
    }
    
    /**Método encargado de consultar y organizar la información de las representaciones legales de un profesional */
    private void consultarRepresentacionLegal(){
        representaciones = new List<HBT_RepresentacionLegalDTO>();
        for(HBT_Representacion_legal__c representacionLegalI :[SELECT ID, Entidad__c, NIT__c, Digito_verificacion__c, Clase_representante__c, Fecha_desde__c, Fecha_hasta__c, 
                                                               Fecha_designacion__c  FROM HBT_Representacion_legal__c WHERE Profesional__c =:contacto.id WITH SECURITY_ENFORCED]){
                                                                   HBT_RepresentacionLegalDTO representacionLegal = new HBT_RepresentacionLegalDTO();
                                                                   representacionLegal.convertirObjetoADTO(representacionLegalI);
                                                                   representaciones.add(representacionLegal);
                                                               }
        
    }
    
    /**Método encargado de consultar y organizar la información de las investigaciones de un profesional */
    private void consultarInvestigaciones(){
        investigaciones = new List<HBT_InvestigacionDTO>();
        for(HBT_Investigacion__c investigacionI :[SELECT Id,Entidad__c, Cual__c, Estado__c, Motivo_investigacion__c, Fecha_desde__c, Fecha_hasta__c  FROM HBT_Investigacion__c
                                                  WHERE Profesional__c =:contacto.id WITH SECURITY_ENFORCED]){
                                                      HBT_InvestigacionDTO investigacion = new HBT_InvestigacionDTO();
                                                      investigacion.convertirObjetoADTO(investigacionI);
                                                      investigaciones.add(investigacion);
                                                  }
        
    }
    /**Método que se encarga de consultar la información de las sanciones de un profesional */
    private void consultarSanciones(){
        sanciones = new List<HBT_SancionDTO>();
        for(HBT_Sancion__c sancionI :[SELECT Id, Cual__c, entidad__c, Tipo_sancion__c, Tipo_documento_sancion__c, Numero_documento_sancion__c,
                                      Valor_multa__c FROM HBT_Sancion__c  WHERE profesional__c = :contacto.id  WITH SECURITY_ENFORCED]){
                                          HBT_SancionDTO sancion = new HBT_SancionDTO();
                                          sancion.convertirObjetoADTO(sancionI);
                                          sanciones.add(sancion);
                                      }
        
    }
    
    /**Método que se encarga de consultar y organizar la información a académica de un profesional */
    private void consultarInforamcionAcademica(){
        informacionesAcademica = new List<HBT_InformacionAcademicaDTO>();

        
        for(HBT_Informacion_academica__c informacionAcademicaI : [SELECT Id, Institucion_academica__r.name, Otra_institucion_academica__c, Carrera__r.name,
                                                                  Estado_estudio__c, Fecha_terminacion_grado__c, Ciudad__r.name, Nivel_estudio__c, Departamento__c, Formacion_academica__c, Pais__c, 
                                                                  Tipo_curso__c,nombre_curso__c FROM HBT_Informacion_academica__c WHERE profesional__c = :contacto.id  WITH SECURITY_ENFORCED]){
                                                                      HBT_InformacionAcademicaDTO informacionAcademica = new HBT_InformacionAcademicaDTO();
                                                                      informacionAcademica.convertirObjetoADTO(informacionAcademicaI);
                                                                      informacionesAcademica.add(informacionAcademica);
                                                                  }
    }
    
    /**Método que se encarga de consultar toda la información laboral de un profesional */
    private void consultarInformacionLaboral (){
        informacionLaborales = new List<HBT_InformacionLaboralDTO>();
        for(HBT_Informacion_laboral__c informacionLaboralI :[SELECT Id, Labora_actualmente__c,DireccionL__c,Entidad__r.name,Tipo_entidad__c, Codigo_entidad__c,NIT__c,Digito_verificacion__c,
                                                             Pais__c,Departamento__c,Ciudad__r.name,Telefono__c, correo_electronico_corporativo__c, Vinculacion__c, Cargo__c, 
                                                             Funciones_desempena__c, Otras_Funciones__c, Fecha_ingreso__c,Fecha_retiro__c, Fecha_posesion_SFC__c, Fecha_posesion_BVC__c, Fecha_designacion__c, 
                                                             Documento_designacion__c, Numero_designacion__c, motivo_retiro__c FROM HBT_Informacion_laboral__c WHERE profesional__c = :contacto.id 
                                                              WITH SECURITY_ENFORCED ORDER BY Fecha_ingreso__c DESC]){
                                                                 HBT_InformacionLaboralDTO informacionLaboral = new HBT_InformacionLaboralDTO();
                                                                 informacionLaboral.convertirObjetoADTO(informacionLaboralI);
                                                                 informacionLaborales.add(informacionLaboral);
                                                                 
                                                             }
    }
    
    /**Método encargaod de consultar las juntas directivas de un profesional */
    private void consultarJuntaDirectiva(){
        juntaDirectivas = new List<HBT_JuntaDirectivaDTO>();
        for(HBT_Junta_directiva__c juntaDirectivaI :[SELECT Entidad__c, Digito_verificacion__c, Calidad_miembro__c, Fecha_designacion__c, 
                                                     Elegido_desde__c, Elegido_hasta__c, NIT__c, Id FROM HBT_Junta_Directiva__c WHERE profesional__c = :contacto.id  WITH SECURITY_ENFORCED]){
                                                         HBT_JuntaDirectivaDTO juntaDirectiva = new HBT_JuntaDirectivaDTO();
                                                         juntaDirectiva.convertirObjetoADTO(juntaDirectivaI);
                                                         juntaDirectivas.add(juntaDirectiva);
                                                     }
    }
    
    
    /**Clase DTO para el manejo de campos picklist y formatos de fecha */
    public class ContactoDTO{
        /**Atributo que representa el tipo de documento*/
        public String tipoDocumento {get; set;}
        /*Atributo que representa el género */
        public String genero {get; set;}
        /**Atributo nivel de escolaridad */
        public String nivelEscolaridad {get; set;}
        /**Atributo que representa la fecha de nacimiento del profesional */
        public String fechaNacimiento {get;set;}
        /**Atributo que representa el pais de nacionalidad */
        public String paisNacionalidad {get;set;}
        /**Atributo que representa el estado civil */
        public String estadoCivil {get; set;}
    }
    
    
}