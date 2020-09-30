import { LightningElement, api, track, wire } from 'lwc';
import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import getURLHojaVida from '@salesforce/apex/HBT_InformacionProfesionalHelper.getURLHojaVida';
import getFoto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getFoto';
import { refreshApex } from '@salesforce/apex';



export default class HBT_ProgresoHojaVida extends LightningElement {
    @api recordId;
    @track error;
    @track avance;
    @track primerNombre = "";
    @track restoNombre;
    @track urlData;
    @track urlFoto; 
    @track recordIdUser;
    @track activarModal=false;
    @track wiredActivities;
    @track descargar;


    @wire(getAvanceContacto)
    wiredAccounts({
        error,
        data
    }) {

        if (data) {
            this.avance = data;
            this.recordId = data[0].Id;
            this.avance = this.avance[0].Avance__c;
            this.separarPrimerNombre(data[0].Name);
            this.descargar= this.avance != 100 ? false: true;

        } else if (error) {
            this.error = error;

        }
    }

    separarPrimerNombre(nombre) {
        this.primerNombre="";
        this.restoNombre="";
        for (let i = 0; i < nombre.length; i++) {
            if (nombre.charAt(i) != ' ') {
                this.primerNombre += "" + nombre.charAt(i);
            } else {
                this.restoNombre = " " + nombre.substring(i, nombre.length);
                return;
            }
        }

    }
    @wire(getURLHojaVida, { idContacto: '$recordId' })
    getURLHojaVida({ error, data }) {
        if (data) {
            this.urlData = data;
        }
        else if (error) {
            // TODO: manejar error
            console.log("Error", error);
        }
    }
    activar(){
    this.activarModal=true;
    }
    desactivar(){
        this.activarModal=false;
    }

    @wire(getFoto,{recordId: '$recordId'})
    getFoto(value) {
        this.wiredActivities = value;
        const { data, error } = value;
        if (data) {
            this.urlFoto=data[0].SmallPhotoUrl;
            this.recordIdUser=data[0].Id;
        }
        else if (error) {
            // TODO: manejar error
            console.log("Error", error);
        }
    }
    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert("No. of files uploaded : " + uploadedFiles.length);
        console.log(uploadedFiles);
        return refreshApex(this.wiredActivities);

    }



}