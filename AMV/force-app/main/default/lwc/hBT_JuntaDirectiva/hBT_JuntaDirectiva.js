import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getJunta from '@salesforce/apex/HBT_JuntaDirectivaHelper.getJunta';
import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import { refreshApex } from '@salesforce/apex';
import actualizarAplica from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarAplica';
import actualizarPestania from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarPestania';



export default class HBT_JuntaDirectiva extends LightningElement {
    bShowModal = false;
    nit = "";
    @track wiredActivities;
    @track wiredActivities2;
    labora=false;
    activarGuardar=false;
    @track activarAplica=true;
     arregloInicial=[];
    @track activarTodo;

    actualizar() {
        actualizarPestania({ pestania:'juntas' })
          .then(data => {
             return refreshApex(this.wiredActivities2)
          })
          .catch(error => {
            console.log("Error", error);
    
          });
    
    
      }
    activarJuntas(){
        this.activarTodo= this.activarTodo? false:true;
        actualizarAplica({campoAplica: this.activarTodo, tipo: 'juntas'})
        .then(data => {
            this.actualizar();
             refreshApex(this.wiredActivities2);

        })
        .catch(error => {
            console.log("Error",error);
            
        });
        

    }
    exito(event) {
        const toastEvent = new ShowToastEvent({
            title: "Junta directiva guardada",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.bShowModal = false;
        this.activar = true;
        this.labora=false;
        refreshApex(this.wiredActivities2);
        return refreshApex(this.wiredActivities);

    }



    crearInformacionAcademica(event) {
        console.log("Info creada");

    }

    activarCrear() {
        this.bShowModal = true;
    }
    desactivarCrear() {
        this.bShowModal = false;
    }
    error(event) {
        const toastEvent = new ShowToastEvent({
            title: "Error al guardar la información",
            message: "Record Id: " + event.detail.id,
            variant: "error"
        });
        this.dispatchEvent(toastEvent);
    }
    valor(event) {
        let aux = event.target.value;
        if (aux.length >= 10) {
            this.nit = aux.substring(0, 11);
        }
    }
    @track error;
    @track accList = [];
    @wire(getJunta)
    wiredAccounts(value) {
        this.wiredActivities = value;
        const { data, error } = value;
        if (data) {
            this.arregloAux = data;
            this.metodoPrueba();
            if(this.arregloAux.length>0){
                this.activarAplica=false;
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
            this.activarTodo=data[0].Informacion_Junta_Directiva__c;

        } else if (error) {
            console.log("Error", error);

        }
    }
    activar = true;
    editar(event) {
        this.accList=this.arregloInicial;

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
        this.accList=this.arregloInicial;

        this.labora=false;
    }
    checkLabora(event){
        this.labora=event.target.value;
        this.accList[event.target.name].trabaja=this.labora;

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
    metodoPrueba() {
      this.accList=[];
        for (let i = 0; i < this.arregloAux.length; i++) {
            this.accList.push({
                Id: this.arregloAux[i].Id,
                Entidad__c: this.arregloAux[i].Entidad__c,
                activar: true,
                trabaja:this.arregloAux[i].Labora_entidad_publica__c
            })

        }
        this.arregloInicial=this.accList;
    }


}