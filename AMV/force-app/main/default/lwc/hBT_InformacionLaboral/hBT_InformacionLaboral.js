import { LightningElement, api, track, wire } from 'lwc';
import getInfoLaboral from '@salesforce/apex/HBT_InformacionLaboralHelper.getInfoLaboral';
import getEntidadOtra from '@salesforce/apex/HBT_InformacionLaboralHelper.getEntidadOtra';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import obtenerInformacionProfesional from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import { refreshApex } from '@salesforce/apex';
import actualizarAplica from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarAplica';
import actualizarPestania from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarPestania';


export default class HBT_InformacionLaboral extends LightningElement {
    @api recordId;
    @track bShowModal = false;
    @track bShowModalConfirmacion = false;

    funciones = [];
    activarCampoOtrasFunciones = false;
    activar = true;
    activarCamposPublicos = false;
    activarCampoFechaRetiro = true;
    @track wiredActivities;
    @track wiredActivities2;
    @track wiredActivities3;
    @track idOtraEntidad;
    activarNitDigito = false;
    @track activarAplica = true;
    complementoDireccion="";
    arregloInicial=[];
    abrirConfirmacion(){
        this.bShowModalConfirmacion=true;
    }
    cerrarConformacion(){
        this.bShowModalConfirmacion=false;
    }
    obtenerDireccion(event){
        this.complementoDireccion=event.target.value;
        this.accList[i].complementario=this.complementoDireccion;
      }


    @track activarTodo;
    activarLaboral() {
        this.activarTodo = this.activarTodo ? false : true;
        actualizarAplica({ campoAplica: this.activarTodo, tipo: 'laboral' })
            .then(data => {
                refreshApex(this.wiredActivities2);

            })
            .catch(error => {
                console.log("Error", error);

            });


    }

    exito(event) {
        const toastEvent = new ShowToastEvent({
            title: "Información laboral guardada",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.bShowModal = false;
        this.bShowModalConfirmacion=false;
        this.activar = true;
        this.editarFalse();
        this.activarCampoOtrasFunciones = false;
        this.activarCamposPublicos = false;
        this.activarCampoFechaRetiro = true;
        refreshApex(this.wiredActivities2);
        return refreshApex(this.wiredActivities);

    }
    labora = true;

    obtenerFunciones(event) {
        this.funciones = event.target.value;

        if (this.funciones.includes('14')) {

            this.activarCampoOtrasFunciones = true;
        } else {
            this.activarCampoOtrasFunciones = false;
        }


    }
    @track profesional;
    @wire(obtenerInformacionProfesional)
    wiredInformacionProfesional(value) {
        this.wiredActivities2 = value;
        const { data, error } = value;
        if (data) {
            this.profesional = data[0].Id;
            this.activarTodo = data[0].Informacion_laboral__c;

        } else if (error) {
            console.log("Error", error);

        }
    }

    @wire(getEntidadOtra)
    wiredOtraEntidad(value) {
        this.wiredActivities3 = value;
        const { data, error } = value;
        if (data) {
            this.idOtraEntidad = data.Id;


        } else if (error) {
            console.log("Error", error);

        }
    }
    editar() {
        this.activar = false;

    }

    holi(event) {
        console.log("Pruebita", event.target.value);
    }

    arregloAux = [];
    @track error;
    @track accList;
    @wire(getInfoLaboral)
    wiredConsultarInformacionLaboral(value) {
        this.wiredActivities = value;
        const { data, error } = value;
        if (data) {
            this.arregloAux = data;
            this.convertirArregloPrincipal();
            if (this.arregloAux.length > 0) {
                this.activarAplica = false;
            }

        } else if (error) {
            this.error = error;
        }
    }
    editar(event) {
        this.accList=this.arregloInicial;
        this.activarAcordeon(parseInt(this.covertirId(event.target.id)));
        for (let i = 0; i < this.accList.length; i++) {
            if (i === parseInt(this.covertirId(event.target.id))) {
                this.accList[i].activar = false;
            } else {
                this.accList[i].activar = true;

            }
        }
    }

    activarAcordeon(nombre) {

        const accordion = this.template.querySelector('.prueba');

        accordion.activeSectionName = nombre;
    }
    covertirId(texto) {
        let aux = "";
        for (let i = 0; i < texto.length; i++) {
            if (texto.charAt(i) != '-') {
                aux += texto.charAt(i);
            } else {
                return aux;
            }
        }
    }
    editarFalse() {
        this.activarCampoOtrasFunciones = false;
        this.activarCamposPublicos = false;
        this.activarCampoFechaRetiro = true;
        for (let i = 0; i < this.accList.length; i++) {
            this.accList[i].activar = true;
        }
    }
    activarCrear() {
        this.complementoDireccion="";
        this.bShowModal = true;
    }
    desactivarCrear() {
        this.bShowModal = false;
        this.activarCampoOtrasFunciones = false;
        this.activarCamposPublicos = false;
        this.activarCampoFechaRetiro = true;
    }
    obtenerEntidad(event) {
        this.activarNitDigito = event.target.value === this.idOtraEntidad ? true : false;

    }
    checkLarobaActualmenteEditar(event){

        for (let i = 0; i < this.accList.length; i++) {
            if (this.accList[i].Id === this.covertirId(event.target.id)) {
                this.accList[i].labora = event.target.value;
            }
        }
    }

    checkPublicosEditar(event){

        for (let i = 0; i < this.accList.length; i++) {
            if (this.accList[i].Id === this.covertirId(event.target.id)) {
                this.accList[i].entidad = event.target.value;
            }
        }
    }

    checkTrabajo(event) {
        this.activarCamposPublicos = event.target.value;
    }
    checkLarobaActualmente(event) {
        this.activarCampoFechaRetiro = event.target.value;
    }
    @track arregloAux = [];
    convertirArregloPrincipal() {
        this.accList = [];
        for (let i = 0; i < this.arregloAux.length; i++) {
            this.accList.push({
                Id: this.arregloAux[i].Id,
                Cargo__c: this.arregloAux[i].Cargo__c,
                labora: this.arregloAux[i].Labora_actualmente__c,
                entidad: this.arregloAux[i].Entidad_publica__c,
                activar: true,
                complementario: this.arregloAux[i].Complemento__c
            })

        }
           this.arregloInicial=this.accList;
    }
}