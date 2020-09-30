import getAvanceContacto from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import getCertificaciones from '@salesforce/apex/HBT_RegistrarExamenProfesionalHelper.getCertificaciones';
import getExamenesPagar from '@salesforce/apex/HBT_RegistrarExamenProfesionalHelper.getExamenesPagar';
import asignarProfesional from '@salesforce/apex/HBT_RegistrarExamenProfesionalHelper.asignarProfesional';


import { LightningElement, track, wire } from 'lwc';
const columns = [
    { label: 'Código del exámen', fieldName: 'codigo',type: 'text' },
    { label: 'Nombre del exámen', fieldName: 'Name', type: 'text' },
    { label: 'Estado', fieldName: 'Estado__c', type: 'text' },
    { label: 'Tarifa', fieldName: 'Tarifa__c', type: 'currency' },
    { label: 'Certificacion', fieldName: 'Certificacion__c', type: 'text' },
];

export default class HBT_TabsGestionExamenesProfesional extends LightningElement {
    data = [];
    columns = columns;
    abrirModalRegistrarExamen = false;
    @track wiredCertifica;
    @track arregloConsulta;
    @track arregloSelect=[];
    @track value;
    @track arregloSeleccionados=[];
    @track wiredActivities2;
    @track wiredActivities;
    activarAgregarCarrito=false;

    @track profesional;

    abrirRegistrarExamen() {
        this.abrirModalRegistrarExamen = true;
    }
    cerrarRegistrarExamen() {
        this.abrirModalRegistrarExamen = false;
    }

    get options() {
        return this.arregloSelect;
    }
    consultarFiltro(event) {
        this.arregloSeleccionados=[]
        getExamenesPagar({idCertificacion: event.target.value})
            .then(result => {
                let aux=[];
                this.data=result;
                
                for (let i = 0; i < this.data.length; i++) {
                    aux.push({Id: this.data[i].Id,
                         codigo: this.data[i].Nombre_examen__c,
                         Name: this.data[i].Examen__r.Name,
                         Estado__c: this.data[i].Examen__r.Estado__c, 
                         Tarifa__c:this.data[i].Examen__r.Tarifa__c,
                         Certificacion__c: this.data[i].Certificacion__r.Name,
                        examen: this.data[i].Examen__c  })
                }
                this.data=aux;


            })
            .catch(error => {
                console.log("Error",error);
            });
    }
    agregarCarrito(){
        this.wiredAsignarProfesional();
    }
    capturarDatosTabla(event){

        const selectedRows = event.detail.selectedRows;
        this.arregloSeleccionados=[];
        this.activarAgregarCarrito=selectedRows.length>0?true:false;

        for (let i = 0; i < selectedRows.length; i++){
            this.arregloSeleccionados.push({Id:selectedRows[i].Id,
                Examen__c: this.obtenerIdExamen(selectedRows[i].Id)
            })
        }

    }
    obtenerIdExamen(id){
        for (let i = 0; i < this.data.length; i++) {
            if(this.data[i].Id===id){
                return this.data[i].examen;
            }
        }

    }
    
    @wire(getCertificaciones)
    wiredCertificaciones(value) {
        this.wiredCertifica = value;
        this.arregloSelect=[];
        const { data, error } = value;
        if (data) {
            this.arregloConsulta=data;
           for (let i = 0; i < this.arregloConsulta.length; i++) {
              this.arregloSelect.push({label:this.arregloConsulta[i].Name, value: this.arregloConsulta[i].Id});                           
           }
           this.arregloSelect.push({label:'Todos', value: ''});     

        } else if (error) {
            console.log("Error", error);
        }
    }
    /**
 * Metodos wire
 */
@wire(getAvanceContacto)
wiredProfesional(value) {
    this.wiredActivities2 = value;
    const { data, error } = value;
    if (data) {
        this.profesional = data[0].Id;
    } else if (error) {
        console.log("Error", error);
    }
}

wiredAsignarProfesional(){
    asignarProfesional({lista: this.arregloSeleccionados, idProfesional: this.profesional})
    .then(data =>{
    })
    .catch(error =>{
        console.log("Error",error);
    })

    
    
}
}