import { LightningElement, api, track, wire } from 'lwc';
import obtenerInformacionProfesional from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class HBT_InformacionBasica extends LightningElement {
    recordId;
    activarPersonal = true;
    activarContacto = true;
    activarNotificaciones = true;
    @track idDireccion;
    @track wiredActivities;
    @track error;
    @track avance;
    infoComplementoContacto="";
    infoComplementoResidencia="";

    /**
     * Metodos para editar cada una de las secciones del acordeon
     */
    editarPersonal() {
        this.activarPersonal = false;
        this.activarNotificaciones = true;
        this.activarContacto = true;
        this.activarAcordeon1();
    }
    editarContacto() {
        this.activarPersonal = true;
        this.activarNotificaciones = true;
        this.activarContacto = false;
        this.activarAcordeon2();

    }
    editarNotificacion() {
        this.activarPersonal = true;
        this.activarNotificaciones = false;
        this.activarContacto = true;
        this.activarAcordeon3();

    }


    /**
     * Metodo que muestra el mensaje de exito al modificar la informacion basica
     */
    exito(event) {
        const toastEvent = new ShowToastEvent({
            title: "Información básica guardada",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.activarPersonal = true;
        this.activarContacto = true;
        this.activarNotificaciones = true;
        return refreshApex(this.wiredActivities);

    }
    /**
     * Metodos que cancelan la edicion de las secciones del acordeon
     */
    editarFalse1() {
        this.activarPersonal = true;
    }
    editarFalse2() {
        this.activarContacto = true;
    }
    editarFalse3() {
        this.activarNotificaciones = true;
    }


    /**
     * Metodos que activan las secciones del acordeon
     */
    activarAcordeon1() {
        const accordion = this.template.querySelector('.claseAcordeon');
        accordion.activeSectionName = 'A';
    }
    activarAcordeon2() {
        const accordion = this.template.querySelector('.claseAcordeon');
        accordion.activeSectionName = 'B';
    }
    activarAcordeon3() {
        const accordion = this.template.querySelector('.claseAcordeon');
        accordion.activeSectionName = 'C';
    }
    obtenerDireccionContacto(event){
      this.infoComplementoContacto=event.target.value;
    }
    obtenerDireccionResidencia(event){
        this.infoComplementoResidencia=event.target.value;
      }

    /**
     * Metodo wire que trae la informacion del profesional
     */
    @wire(obtenerInformacionProfesional)
    wiredProfesional(value) {
        this.wiredActivities = value;
        const { data, error } = value;
        if (data) {
            this.recordId = data[0].Id;
            this.idDireccion = data[0].Direccion_residencia__c;

        } else if (error) {
            this.error = error;

        }
    }
}