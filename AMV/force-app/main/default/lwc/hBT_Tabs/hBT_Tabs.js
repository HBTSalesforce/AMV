import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';

import { LightningElement, wire, api, track } from 'lwc';

export default class HBT_Tabs extends LightningElement {
    @track recordId;
    @track wiredActivities2;
    @track completitudSancion;
    @track completitudAcademica;
    @track completitudLaboral;
    @track completitudJuntas;
    @track completitudInvestigaciones;
    @track completitudRepresentaciones;
    @track completitudActividadMercadoValores;
    @track completitudPreguntas;
    @track pestanaActiva= undefined;
    @track activarPestanias = false;
    @track academica;
    @track laboral;
    @track juntas;
    @track representaciones;
    @track sanciones;
    @track investigaciones;
    @track mercado;
    @track preguntas;
    @track activarPreguntas;

    @wire(getAvanceContacto)
    wiredAcda(value) {
        this.wiredActivities2 = value;
        const { data, error } = value;
        let aux="";


        if (data) {

            aux= data[0].Utilima_pestana_modificada__c;
            this.recordId = data[0].Id;
            this.completitudSancion = data[0].Informacion_sancion_completa__c;
            this.completitudAcademica = data[0].Informacion_academica_completa__c;
            this.completitudLaboral = data[0].Informacion_laboral_completa__c;
            this.completitudJuntas = data[0].Informacion_junta_directiva_completa__c;
            this.completitudInvestigaciones = data[0].Informacion_investigacion_completa__c;
            this.completitudRepresentaciones = data[0].Informacion_representacion_completa__c;
            this.completitudActividadMercadoValores = data[0].Informacion_actividad_mercado_completa__c;
            this.completitudPreguntas=data[0].Informacion_preguntas_completa__c;
            
              this.academica= this.completitudAcademica?'utility:check':'none';
              this.laboral=this.completitudLaboral? 'utility:check': 'none';
              this.juntas=this.completitudJuntas? 'utility:check': 'none';
              this.representaciones= this.completitudRepresentaciones? 'utility:check': 'none';
              this.investigaciones=this.completitudInvestigaciones? 'utility:check': 'none';
              this.sanciones= this.completitudSancion? 'utility:check': 'none';
              this.mercado= this.completitudActividadMercadoValores? 'utility:check': 'none';   
              this.preguntas= this.completitudPreguntas?'utility:check': 'none';
             
              if(data[0].Cantidad_investigaciones__c>0 || data[0].Cantidad_sanciones__c>0){
                  this.activarPreguntas=true;
              }else{
                  this.activarPreguntas=false;
              }


        } else if (error) {
            console.log("Error", error);
        }
    }




}