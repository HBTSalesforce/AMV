import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getActividadMercadoValores from '@salesforce/apex/HBT_ActividadMercadoValoresHelper.getActividadMercadoValores';
import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import { refreshApex } from '@salesforce/apex';
import actualizarAplica from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarAplica';

export default class HBT_ActividadMercadoValores extends LightningElement {


    bShowModal = false;
    @track wiredActivities;
    @track wiredActivities2;
    activarGuardar=false;
    @track activarNoAplica=false;
    @track activarTodo;

    /**Método que indica si se activa o no la información para el mercado de valores */
    activarMercadoValores(){
        this.activarTodo= this.activarTodo? false:true;
        actualizarAplica({campoAplica: this.activarTodo, tipo: 'mercadoValores'})
        .then(data => {
           return refreshApex(this.wiredActivities2);

        })
        .catch(error => {
            console.log("Error",error);
            
        });
        

    }
    /**Método que lanza el mensaje de éxito  en caso que sea exitoso el guardado */
    exito(event) {
        const toastEvent = new ShowToastEvent({
            title: "Actividad de mercado de valores guardada",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.bShowModal = false;
        this.activar = true;
        refreshApex(this.wiredActivities2)
        return refreshApex(this.wiredActivities);

    }
    /**Método que lanza el mensaje de error en caso que falle el guardado */
    error(event) {
        const toastEvent = new ShowToastEvent({
            title: "Error al guardar la información",
            message: "Record Id: " + event.detail.id,
            variant: "error"
        });
        this.dispatchEvent(toastEvent);
    }

    /**Método que activa el modal de creación */
    activarCrear() {
        this.bShowModal = true;
    }
    /**Méto que cierra el modal de creación */
    desactivarCrear() {
        this.bShowModal = false;
    }
    crearMercadoValores(event) {
        console.log("Info creada");

    }



    @track error;
    @track accList = [];
    @wire(getActividadMercadoValores)
    wiredActividadMercadoValores(value) {
        this.wiredActivities = value;
        const { data, error } = value
        if (data) {
            this.arregloAux = data;
            if(this.arregloAux.length>0){
                this.construirListaActividades();
                this.activarNoAplica=false;
            }else{
                this.activarNoAplica=true;

            }
        } else if (error) {
            this.error = error;
        }
    }


    @track profesional;
    @wire(getAvanceContacto)
    wiredAcda(value) {
        this.wiredActivities2 = value;
        const { data, error } = value;
        if (data) {
            this.profesional = data[0].Id;
            this.activarTodo=data[0].Informacion_actividad_mercado_valores__c;

        } else if (error) {
            console.log("Error", error);

        }
    }
    activar = true;
    editar(event) {
        this.activarAcordeon(parseInt(this.covertirId(event.target.id)));
        for (let i = 0; i < this.accList.length; i++) {
              if(i===parseInt(this.covertirId(event.target.id))){
                  this.accList[i].activar=false;
              }else{
                this.accList[i].activar=true;
 
              }
        }
    }

    activarAcordeon(nombre) {

        const accordion = this.template.querySelector('.prueba');
        accordion.activeSectionName = nombre;
    }
    editarFalse() {
        for (let i = 0; i < this.accList.length; i++) {
                 this.accList[i].activar=true;            
        }
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
    @track arregloAux = [];
    construirListaActividades() {
      this.accList=[];
        for (let i = 0; i < this.arregloAux.length; i++) {
            this.accList.push({
                Id: this.arregloAux[i].Id,
                Entidad__c: this.arregloAux[i].Entidad__c,
                activar: true
            })

        }

    }
}