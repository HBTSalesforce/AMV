import { LightningElement, wire, track, api } from 'lwc';
import EXAMENPROFESIONAL_OBJECT from '@salesforce/schema/HBT_Examen_profesional__c';
import getExamenes from '@salesforce/apex/HBT_GestionExamenProfesionalController.getExamenesPorEstado';
import { getRecord } from 'lightning/uiRecordApi';



export default class HBT_ExamenesPendientesPago extends LightningElement {

    @track examanesList = [];
    @api examenid;
    mostrarTabla = false;
    bShowModal = false;
    COLUMNAS = [
      //  { label: 'Nombre', fieldName: 'urlExamen',  type: 'url', editable: false,typeAttributes: {label: { fieldName: 'nombre' }, target: '_blank'} },
      { label: 'Nombre del exámen', fieldName: 'nombre', editable: false },  
      { label: 'Canal de presentación', fieldName: 'canal', editable: false },
        { label: 'Estado', fieldName: 'estado', editable: false },
        { type: 'button', initialWidth: 100, typeAttributes: { label: 'Agendar', name: 'agendar', variant: 'base' } },
        { type: 'button', initialWidth: 100, typeAttributes: { label: 'Ver Detalle', name: 'ver', variant: 'base' } }
    ];

    
    @wire(getExamenes, {estado : 'Pagado'})
    obtenerExamenes({ error, data }) {
        if (data) {
            this.examanesList = data;
           if(this.examanesList.length > 0){
            this.mostrarTabla = true;
           }else{
            this.mostrarTabla = false; 
           }
        }
        else if (error) {
            // TODO: manejar error
        }
    }

    handleRowAction(event) {
        console.log(JSON.stringify(event.detail.action));
        console.log(event.detail.row.id);
        console.log('canal'+(event.detail.row.canal));
      
        if(event.detail.action.name==='agendar') {
            this.examenid = event.detail.row.id+';'+event.detail.row.canal;
            this.openModal();
        } else if (event.detail.action.name==='second_button') {
            console.log('clicked SECOND button');
        }
    }

    /* javaScipt functions start */
    openModal() {
        // to open modal window set 'bShowModal' tarck value as true
        this.bShowModal = true;
    }

    closeModal() {
        console.log('va a cerrar');
        // to close modal window set 'bShowModal' tarck value as false
        this.bShowModal = false;
    }

}