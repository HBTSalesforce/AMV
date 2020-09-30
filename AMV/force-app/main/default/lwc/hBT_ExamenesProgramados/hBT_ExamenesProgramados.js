import { LightningElement, wire, track } from 'lwc';
import getExamenes from '@salesforce/apex/HBT_GestionExamenProfesionalController.getAgendasProfesional';

export default class HBT_ExamenesProgramados extends LightningElement {

    //Lista para almacenar los exámenes consultados
    @track examanesList = [];
    mostrarTabla = false;
    COLUMNAS = [
        { label: 'Número de documento', fieldName: 'numeroDocumento', editable: false },
        { label: 'Nombre del profesional', fieldName: 'nombreProfesional', editable: false },
        { label: 'Nombre del exámen', fieldName: 'nombre', editable: false },
        { label: 'Canal de presentación', fieldName: 'canal', editable: false },
        { label: 'Ciudad', fieldName: 'ciudad', editable: false },
        { label: 'Sala', fieldName: 'nombreSala', editable: false },
        { label: 'Dirección', fieldName: 'direccion', editable: false },
        { label: 'Fecha para presentar el examen', fieldName: 'fechaPresentacion', editable: false },
        { label: 'Hora', fieldName: 'hora', editable: false },
        { label: 'Estado', fieldName: 'estado', editable: false },
        { label: 'Fecha de vencimiento', fieldName: 'fechaVencimiento', editable: false },
        { type: 'button', initialWidth: 100, typeAttributes: { label: 'Agendar', name: 'agendar', variant: 'base' } },
        { type: 'button', initialWidth: 100, typeAttributes: { label: 'Ver Detalle', name: 'ver', variant: 'base' } }
    ];

    @wire(getExamenes, {estado : 'Pendiente por Presentar'})
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

    //Método que maneja los eventos sobre las filas
    handleRowAction(event) {
        console.log(JSON.stringify(event.detail.action));
        console.log(JSON.stringify(event.detail.id));
        if(event.detail.action.name==='agendar') {
            this.openModal();
        } else if (event.detail.action.name==='second_button') {
            console.log('clicked SECOND button');
        }
    }

}