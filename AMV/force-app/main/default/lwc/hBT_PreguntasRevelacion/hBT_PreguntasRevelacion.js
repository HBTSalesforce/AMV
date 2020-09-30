import { LightningElement,wire, api,track } from 'lwc';
import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import getPreguntas from '@salesforce/apex/HBT_PreguntasRevelacionHelper.getPreguntas';
import getFiles from '@salesforce/apex/HBT_PreguntasRevelacionHelper.getFiles';
import eliminar from '@salesforce/apex/HBT_PreguntasRevelacionHelper.deleteFile';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class HBT_PreguntasRevelacion extends LightningElement {
    @track bShowModal = false;
    @track error;
    @track accList=[];
    @track profesional;
    @track arregloAux;
    @api recordId;
    @track wiredDocumentos;
    @track archivos;
    @track wiredActivities;
    @track wiredActivities2;
    @track activarJustificaion1=false;
    @track activarJustificaion2=false;
    @track activarJustificaion3=false;
    @track activarJustificaion4=false;
    @track activarJustificaion1D=false;
    @track activarJustificaion2D=false;
    @track activarJustificaion3D=false;
    @track activarJustificaion4D=false;
    @track activarMostrar=false;
    @track activarAgregar=false;
    @track editar=false;
    @track activarSubir=false;




    activarCrear() {
        this.bShowModal = true;
        this.setearVariables();
    }
    obtenerPreguntaUno(event){
    this.activarJustificaion1= event.target.value==='Si'? true: false;

    }
    obtenerPreguntaDos(event){
        this.activarJustificaion2= event.target.value==='Si'? true: false;
    
        }
    obtenerPreguntaTres(event){
        this.activarJustificaion3= event.target.value==='Si'? true: false;
        
         }
         obtenerPreguntaCuatro(event){
            this.activarJustificaion4= event.target.value==='Si'? true: false;
            
             }
    desactivarCrear() {
        this.bShowModal = false;
        this.setearVariables();
    }
    exito(event) {
        const toastEvent = new ShowToastEvent({
            title: "Preguntas guardadas",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.bShowModal = false;
        this.setearVariables();
        this.activarAgregar=false;
        refreshApex(this.wiredActivities2);
     return refreshApex(this.wiredActivities);

    }
    setearVariables(){
        this.activarJustificaion1=false;
        this.activarJustificaion2=false;
        this.activarJustificaion3=false;
        this.activarJustificaion4=false;
    }

    edicion(){
        this.editar=true;
    }
    cancelarEdicion(){
        this.editar=false;

    }

    @wire(getAvanceContacto)
    wiredAcda(value) {
        this.wiredActivities2 = value;
        const { data, error } = value;
        if (data) {
            this.profesional = data[0].Id;
        } else if (error) {
            console.log("Error", error);
        }
    }
    convertirArregloPrincipal(){
        this.activarJustificaion1D=this.arregloAux[0].Pregunta_1__c==='Si'?true:false;
        this.activarJustificaion2D=this.arregloAux[0].Pregunta_2__c==='Si'?true:false;
        this.activarJustificaion3D=this.arregloAux[0].Pregunta_3__c==='Si'?true:false;
        this.activarJustificaion4D=this.arregloAux[0].Pregunta_4__c==='Si'?true:false;
        this.activarJustificaion1=this.arregloAux[0].Pregunta_1__c==='Si'?true:false;
        this.activarJustificaion2=this.arregloAux[0].Pregunta_2__c==='Si'?true:false;
        this.activarJustificaion3=this.arregloAux[0].Pregunta_3__c==='Si'?true:false;
        this.activarJustificaion4=this.arregloAux[0].Pregunta_4__c==='Si'?true:false;
        
    }
    get formatosAceptados() {
        return ['.pdf', '.png', '.jpg', '.doc','.txt','.docx','.odt','.xls','.xlsx','.jpeg'];
    }
    @wire(getFiles)   
    documentos(value){
     this.wiredDocumentos=value;
     const {data,error}= value;
     if(data){
         this.archivos=data;
         this.activarSubir=this.archivos.length>0?false:true;
         if(this.archivos.length>0){
            this.url=data[0];
            this.idArchivo= this.obtenerId(this.url);
         }

     }else if(error){
   
     }
    }
    eliminarArchivo(){

       eliminar({contentDocumentId: this.idArchivo})
        .then(data => {
    
            const toastEvent = new ShowToastEvent({
                title: "Eliminado exitosamente",
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
    
           return refreshApex(this.wiredDocumentos);
    
        })
        .catch(error => {
            console.log("Error",error);
            
        });
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

    cargaFinalizar(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        return refreshApex(this.wiredDocumentos);

       // return refreshApex(this.wiredArchivos);
    }

    @wire(getPreguntas)
    wiredPreguntas(value) {
        this.wiredActivities = value;
        const { data, error } = value;
        if (data) {
            this.arregloAux = data;
            if(this.arregloAux.length>0){
                this.convertirArregloPrincipal();
                this.recordId=data[0].Id;
                this.activarMostrar=true;
            }else{
                this.activarAgregar=true;

            }

        } else if (error) {
            console.log("Error",error);
        }
    }

}