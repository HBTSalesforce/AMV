import { LightningElement,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import getRepresentaciones from '@salesforce/apex/HBT_RepresentacionesLegalesHelper.getRepresentaciones';
import { refreshApex } from '@salesforce/apex';
import actualizarAplica from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarAplica';
import actualizarPestania from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarPestania';


export default class HBT_RepresentacionesLegales extends LightningElement {
    bShowModal=false;
    activar=true;
    @track wiredActivities;
    @track wiredActivities2;
    @track activarTodo;
    @track activarAplica=true;
    activarOtros=false;
    arregloInicial=[];

    
    activarRepresentaciones(){
        this.activarTodo= this.activarTodo? false:true;
        actualizarAplica({campoAplica: this.activarTodo, tipo: 'representaciones'})
        .then(data => {
             refreshApex(this.wiredActivities2);

        })
        .catch(error => {
            console.log("Error",error);
            
        });
        

    }
    activarCrear() {
        this.activarOtros=false;
        this.bShowModal = true;
    }
    desactivarCrear() {
        this.bShowModal = false;
        this.activarOtros=false;

    }

    exito(event) {
        const toastEvent = new ShowToastEvent({
            title: "Representación legal guardada",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
        this.bShowModal=false;
        this.activar=true;
        this.activarOtros=false;
        refreshApex(this.wiredActivities2);
        return refreshApex(this.wiredActivities);
    }
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
      this.accList=this.arregloInicial;
        for (let i = 0; i < this.accList.length; i++) {
                 this.accList[i].activar=true;            
        }
    }

    @track error;
@track accList;
@wire(getRepresentaciones)
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
otro(event){
this.activarOtros=event.target.value;
this.accList[event.target.name].otro=this.activarOtros;

}
@track profesional;
@wire(getAvanceContacto)
wiredAcda(value) {
    this.wiredActivities2 = value;
    const { data, error } = value;
    if (data) {
        this.profesional = data[0].Id;
        this.activarTodo=data[0].Informacion_representacion_legal__c;

       
    } else if (error) {
        console.log("Error",error);

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
            otro:this.arregloAux[i].Otra_representacion_legal__c
        })

    }
    this.arregloInicial=this.accList;

}

}