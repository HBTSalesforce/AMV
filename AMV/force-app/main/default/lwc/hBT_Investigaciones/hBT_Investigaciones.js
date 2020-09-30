import getFiles from '@salesforce/apex/HBT_InvestigacionesHelper.getFiles';
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getInvestigaciones from '@salesforce/apex/HBT_InvestigacionesHelper.getInvestigaciones';
import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import { refreshApex } from '@salesforce/apex';
import deleteFile from '@salesforce/apex/HBT_InvestigacionesHelper.deleteFile';
import actualizarAplica from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarAplica';

export default class HBT_Investigaciones extends LightningElement {
    bShowModal = false;
    activar = true;
    @track wiredActivities;
    @track wiredActivities2;
    @track wiredDocumentos;
    activarCual = false;
    @track activarTodo;
    @track activarAplica=true;
    @track archivos=[];
    @track contador=0;


    activarInvestigaciones(){
        this.activarTodo= this.activarTodo? false:true;
        actualizarAplica({campoAplica: this.activarTodo, tipo: 'investigacion'})
        .then(data => {
            refreshApex(this.wiredActivities2);

        })
        .catch(error => {
            console.log("Error",error);
            
        });
        

    }
    activarCrear() {
        this.bShowModal = true;
    }
    desactivarCrear() {
        this.bShowModal = false;
    }
    exito(event) {
        const toastEvent = new ShowToastEvent({
            title: "Información laboral guardada",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.bShowModal = false;
        this.activar = true;
        refreshApex(this.wiredActivities2);
        return refreshApex(this.wiredActivities);

    }

    @wire(getFiles)   
    documentos(value){
     this.wiredDocumentos=value;
     const {data,error}= value;
     if(data){
         this.archivos=data;
         this.metodoPrueba();
   
     }else if(error){
   
     }
    }
    editar() {
        this.activar = false;
    }
    @track profesional;
    @wire(getAvanceContacto)
    wiredAcda(value) {
        this.wiredActivities2 = value;
        const { data, error } = value;
        if (data) {
            this.profesional = data[0].Id;
            this.activarTodo=data[0].Informacion_Investigacion__c;
        } else if (error) {
            console.log("Error", error);
        }
    }

    @track error;
    @track accList;
    @wire(getInvestigaciones)
    wiredInvestigaciones(value) {
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

    editar(event) {
        this.activarAcordeon(parseInt(this.covertirId(event.target.id)));
        for (let i = 0; i < this.accList.length; i++) {
            if (i === parseInt(this.covertirId(event.target.id))) {
                this.accList[i].activar = false;
            } else {
                this.accList[i].activar = true;

            }
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

    activarAcordeon(nombre) {

        const accordion = this.template.querySelector('.prueba');

        accordion.activeSectionName = nombre;
    }
    editarFalse() {
        for (let i = 0; i < this.accList.length; i++) {
            this.accList[i].activar = true;
        }
    }
    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg', '.doc','.txt','.docx','.odt','.xls','.xlsx','.jpeg'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        return refreshApex(this.wiredDocumentos);

       // return refreshApex(this.wiredArchivos);
    }
    obtenerId(url) {
        let aux = "";
        for (let i = url.length; i >= 0; i--) {
            if (url.charAt(i) != '=') {
                aux += url.charAt(i);
            } else {
                let aux2="";
                for (let i =aux.length ; i >=0 ; i--) {
                      aux2+=aux.charAt(i);              
                }
                return aux2;
            }
        }

    }
    @track arregloAux = [];
    metodoPrueba() {
        this.accList = [];
        this.contador++;
        if(this.contador>1){
        for (let i = 0; i < this.arregloAux.length; i++) {
            let aux=[];
    
            for (let j = 0; j < this.archivos.length; j++) {
                if(this.arregloAux[i].Id===this.obtenerIdInvestigacion(this.archivos[j])){
                aux.push({lista: this.archivos[j], id:this.obtenerId(this.archivos[j])})
                }  
            }        
                this.accList.push({
                    Id: this.arregloAux[i].Id,
                    Entidad__c: this.arregloAux[i].Entidad__c,
                    activar: true,
                    lista: aux
                })
    
        }
    
    }
        return;
    
    }
    obtenerIdInvestigacion(url){
        let aux="";
        for (let i = 0; i < url.length; i++) {
            if(url.charAt(i)===' '){
              aux=url.substring(i+1,i+19);
              return aux;
            }
            
        }

    }
    eliminarArchivo(event){
        let aux="";

        deleteFile({contentDocumentId: (this.covertirId(event.target.id))})
        .then(data => {
            this.editarFalse();
    
            const toastEvent = new ShowToastEvent({
                title: "Eliminado exitosamenre",
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
    
           return refreshApex(this.wiredDocumentos);
    
        })
        .catch(error => {
            console.log("Error",error);
            
        });
    }  
    obtenerEntidad(event) {
        console.log(event.target.value);
        if (event.target.value === 'Otras entidades no registradas') {
            this.activarCual = true;
        } else {
            this.activarCual = false;
        }
    }

}