import getFiles from '@salesforce/apex/HBT_SancionesHelper.getFiles';
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import getSanciones from '@salesforce/apex/HBT_SancionesHelper.getSanciones';
import { refreshApex } from '@salesforce/apex';
import deleteFile from '@salesforce/apex/HBT_SancionesHelper.deleteFile';
import actualizarAplica from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarAplica';
import actualizarPestania from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarPestania';


export default class HBT_Sanciones extends LightningElement {
    activar = true;
    @track wiredActivities;
    @track wiredArchivos;
    @track archivos=[];
    arregloArchivos = [];
    activarCual = false;
    bShowModal = false;
    @track arregloAux = [];
    @track profesional;
    @track error;
    @track accList;
    @track listaArchivos;
    @track activarAcor =true;
    @track wiredActivities2;
    @track wiredDocumentos;
    @track activarAplica=true;
    @track contador=0;

    actualizar() {
        actualizarPestania({ pestania:'sanciones' })
          .then(data => {
             return refreshApex(this.wiredActivities2)
          })
          .catch(error => {
            console.log("Error", error);
    
          });
    
    
      }

    @track activarTodo;
    activarSanciones(){
        this.activarTodo= this.activarTodo? false:true;
        actualizarAplica({campoAplica: this.activarTodo, tipo: 'sancion'})
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
            title: "Sanción guardada",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.bShowModal = false;
        this.activar = true;
        this.editarFalse();
        refreshApex(this.wiredActivities2);
        return refreshApex(this.wiredActivities);
    }
    crearSancion(event) {
        console.log("Info creada");

    }
    activarCrear() {
        this.bShowModal = true;
    }
    desactivarCrear() {
        this.bShowModal = false;
    }
    metodo1(){
        this.arregloArchivos=[];
        for (let i = 0; i < this.archivos.length; i++) {
            this.arregloArchivos.push({
                url: this.archivos[i],
                id: this.obtenerId(this.archivos[i])
            })
        }
    }
    obtenerId(url) {
        let aux = "";
        for (let i = url.length; i >= 0; i--) {
            if (url.charAt(i) != '=') {
                aux += url.charAt(i);
            } else {
                let aux2="";
                for (let i = aux.length; i >=0; i--) {
                    aux2+=aux.charAt(i);
                }
                return aux2;
            }
        }

    }

    obtenerIdSancion(url){
        let aux="";
        for (let i = 0; i < url.length; i++) {
            if(url.charAt(i)===' '){
              aux=url.substring(i+1,i+19);
              return aux;
            }
            
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

    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg', '.doc','.txt','.docx','.odt','.xls','.xlsx','.jpeg'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        return refreshApex(this.wiredDocumentos)

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
    busqueda(event){
        console.log("Evento",event);
       // return this.archivos;
        return true;
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

   metodoPrueba() {
    this.accList = [];
    this.contador++;
    if(this.contador>1){
    for (let i = 0; i < this.arregloAux.length; i++) {
        let aux=[];

        for (let j = 0; j < this.archivos.length; j++) {
            if(this.arregloAux[i].Id===this.obtenerIdSancion(this.archivos[j])){
            aux.push({lista: this.archivos[j], id:this.obtenerId(this.archivos[j])})
            }  
        }        
            this.accList.push({
                Id: this.arregloAux[i].Id,
                entidad__c: this.arregloAux[i].entidad__c,
                activar: true,
                lista: aux
            })

    }

}
    return;

}
    guardadoExitosoAplica(){
        this.activarGuardar=false;
    }
eliminarArchivo(event){

    deleteFile({contentDocumentId: this.covertirId(event.target.id)})
    .then(data => {
        this.editarFalse();


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


    obtenerEntidad(event) {
        if (event.target.value === 'Otras entidades no registradas') {
            this.activarCual = true;
        } else {
            this.activarCual = false;
        }
    }

/**
 * Metodos wire
 */
@wire(getAvanceContacto)
wiredAcda(value) {
    this.wiredActivities2 = value;
    const { data, error } = value;
    if (data) {
        this.profesional = data[0].Id;
        this.activarTodo=data[0].Informacion_Sancion__c;
    } else if (error) {
        console.log("Error", error);
    }
}



@wire(getSanciones)
wiredSanciones(value) {
    this.wiredActivities = value;
    const { data, error } = value;
    if (data) {
        this.arregloAux = data;
        this.metodoPrueba();
        if(this.arregloAux.length>0){
            this.activarAplica=false;
        }

    } else if (error) {
        console.log("Error", error);
    }
}


}