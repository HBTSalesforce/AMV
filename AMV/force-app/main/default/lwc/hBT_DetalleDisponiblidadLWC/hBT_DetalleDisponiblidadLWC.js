import { LightningElement, track, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import CONTACT_OBJECT from '@salesforce/schema/HBT_Agenda_sala__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCalendarioList from '@salesforce/apex/HBT_DetalleDisponibilidadController.getCalendarioList';
import getPickListSalaValues from '@salesforce/apex/HBT_DetalleDisponibilidadController.getPickListSalaValues';
import getPickListDuracionValues from '@salesforce/apex/HBT_DetalleDisponibilidadController.getPickListDuracionValues';
import guardarCupo from '@salesforce/apex/HBT_DetalleDisponibilidadController.guardarCupo';
import getDetailDataSelected from '@salesforce/apex/HBT_DetalleDisponibilidadController.getDetailDataSelected';

import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Profile.Name';

const FIELDS = [
    'HBT_Sala__c.Name',
    'HBT_Sala__c.Tipo_sala__c ',
    'HBT_Sala__c.Numero_Cupos__c',
    'HBT_Sala__c.Direccion1__c'
];


const COLS = [
    { label: 'H. Inicio', fieldName: 'hora_inicio__c', editable: false },
    { label: 'H. Fin', fieldName: 'hora_fin__c', editable: false },
    { label: 'Cupos Disponibles', fieldName: 'Cupos_disponibles__c', editable: false },
    { label: 'Total Cupos', fieldName: 'Numero_cupos__c', editable: true }
];

/*const COLS_AGENDA = [
  
    { label: 'Hora', fieldName: 'hora_inicio__c',  type: 'url', editable: false,typeAttributes: {label: { fieldName: 'hora_inicio__c' }} },
];*/

export default class HBT_DetalleDisponiblidadLWC extends LightningElement {
    @api item;
    @track error;
    @track mesActual;
    @track mesActualNumero;
    @track options;
    @track selectedOption;
    @track optionsDuracion;
    @track selectedOptionDuracion;
    @track diaseleccion;
    @track calendatioList;
    @track detalleInfo;
    @track detalleInfoList = [];
    @track searchKey = '';
    datefecha;
    mostrarTabla = true;
    @track columns = COLS;
    //@track columnsAgenda = COLS_AGENDA;
    @track draftValues = [];
    @track name = '';
    @track canal;
    @track idExamen = '';
    @track cupoSeleccionado;
    wiredActivities;
    mostrarSala = true;

    @api recordId;

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
            this.error = error;
        } else if (data) {
            console.log('data '+data.fields.Profile.value.fields.Name.value);
            if (data.fields.Profile.value.fields.Name.value === 'Profesional') {
                this.name = data.fields.Profile.value.fields.Name.value; 
                console.log(this.name);
                console.log(this.item);
                const words = this.item.split(';');
                this.canal = words[1];
                this.idExamen = words[0];

                if(this.canal == 'Virtual'){
                    mostrarSala = false;
                }

                getPickListSalaValues({ tipo: this.canal })
                    .then(data => {
                        this.options = data;
                    })
                    .catch(error => {
                        this.displayError(error);
                    });
            } else {
                this.name = '';
                getPickListSalaValues({ tipo: '' })
                    .then(data => {
                        this.options = data;
                    })
                    .catch(error => {
                        this.displayError(error);
                    });
            }


        }
    }


    @wire(getRecord, { recordId: '$selectedOption', fields: FIELDS })
    sala;

    get name() {
        return this.sala.data.fields.Name.value;
    }

    get cupos() {
        return this.sala.data.fields.Numero_Cupos__c.value;
    }

    get tipo() {
        return this.sala.data.fields.Tipo_sala__c.value;
    }

    get direccion() {
        return this.sala.data.fields.Direccion1__c.value;
    }

    constructor() {
        super();


        /*  getCalendarioList({ fecha: 'actual', sala: this.selectedOption })
              .then(result => {
                  this.calendatioList = result;
              })
              .catch(error => {
                  this.error = error;
              });*/
    }

    connectedCallback() {
        getPickListSalaValues({ tipo: this.canal })
            .then(data => {
                this.options = data;
            })
            .catch(error => {
                this.displayError(error);
            });

        getPickListDuracionValues({})
            .then(data => {
                this.optionsDuracion = data;
            })
            .catch(error => {
                this.displayError(error);
            });
    }


    handleChange(event) {
        console.log(event.detail.value);
        this.selectedOption = event.detail.value;
    }

    handleChangeDuracion(event) {
        console.log(event.detail.value);
        this.selectedOptionDuracion = event.detail.value;
    }

    handleCalendario(event) {
        console.log('sala seleccionada ' + this.selectedOption);
        console.log('duracion seleccionada ' + this.selectedOptionDuracion);
        if (this.selectedOption != 'undefinied') {


            this.datefecha = new Date();
            this.mesActualNumero = this.datefecha.getUTCMonth() + 1;
            this.mesActual = getMonth(this.mesActualNumero);

            getCalendarioList({ fecha: 'actual', sala: this.selectedOption, duracion: this.selectedOptionDuracion, examen: this.idExamen })
                .then(result => {
                    this.calendatioList = result;
                })
                .catch(error => {
                    this.error = error;
                });
        }
    }

    handleMesAnterior(event) {
        console.log('cambiar mes');
        this.mesActualNumero = this.mesActualNumero - 1;
        this.mesActual = getMonth(this.mesActualNumero);

        this.datefecha.setMonth(this.datefecha.getMonth() - 1);
        getCalendarioList({ fecha: this.datefecha, sala: this.selectedOption, duracion: this.selectedOptionDuracion })
            .then(result => {
                this.calendatioList = result;
            })
            .catch(error => {
                this.error = error;
            });

        console.log(event.detail.detail);
    }

    handleMesSiguiente(event) {
        console.log('cambiar mes');
        this.mesActualNumero = this.mesActualNumero + 1;
        this.mesActual = getMonth(this.mesActualNumero);

        this.datefecha.setMonth(this.datefecha.getMonth() + 1);
        getCalendarioList({ fecha: this.datefecha, sala: this.selectedOption, duracion: this.selectedOptionDuracion })
            .then(result => {
                this.calendatioList = result;
            })
            .catch(error => {
                this.error = error;
            });

        console.log(event.detail.detail);
    }

    handleDetalle(event) {
        // event.preventDefault();
        console.log('id => ' + event.target.dataset.id);
        this.diaseleccion = event.target.dataset.id;
        this.searchKey = event.target.dataset.id;
        this.cambioarColor(event.target.dataset.id);
    }

    cambioarColor(obj) {
        console.log('id cambiar color => ' + obj);
        var i;
        let tmpObj = [];
        for (i = 0; i < this.calendatioList.length; i++) {

            var lun = this.calendatioList[i].estadoLun;
            var mar = this.calendatioList[i].estadoMar;
            var mie = this.calendatioList[i].estadoMie;
            var jue = this.calendatioList[i].estadoJue;
            var sab = this.calendatioList[i].estadoSab;
            var dom = this.calendatioList[i].estadoDom;
            var vie = this.calendatioList[i].estadoVie;
         //   console.log('dia  ' + this.calendatioList[i].estadoMar);
         //   console.log('diatemp  ' + this.calendatioList[i].estadoTempMar);
            if (lun == 'seleccion') {

                lun = this.calendatioList[i].estadoTempLun;
            }
            if (mar == 'seleccion') {


                mar = this.calendatioList[i].estadoTempMar;
            }
            if (mie == 'seleccion') {
                mie = this.calendatioList[i].estadoTempMie;
            }
            if (jue == 'seleccion') {
                jue = this.calendatioList[i].estadoTempJue;
            }
            if (vie == 'seleccion') {
                vie = this.calendatioList[i].estadoTempVie;
            }
            if (sab == 'seleccion') {
                sab = this.calendatioList[i].estadoTempSab;
            }
            if (dom == 'seleccion') {
                dom = this.calendatioList[i].estadoTempDom;
            }

            if (this.calendatioList[i].fechadomingo == obj) {
                console.log('lo encontre');
                dom = 'seleccion';
            } else {
                // dom = 'disponible';
            }
            if (this.calendatioList[i].fechalunes == obj) {
                console.log('lo encontre');
                lun = 'seleccion';
            } else {
                // lun = 'disponible';
            }
            if (this.calendatioList[i].fechamartes == obj) {

                console.log('lo encontre');
                mar = 'seleccion';
            } else {
                // mar = 'disponible';
            }
            if (this.calendatioList[i].fechamiercoles == obj) {
                console.log('lo encontre');
                mie = 'seleccion';
            } else {
                //  mie = 'disponible';
            }
            if (this.calendatioList[i].fechajueves == obj) {
                jue = 'seleccion';
            } else {
                //  jue = 'disponible';
            }
            if (this.calendatioList[i].fechaviernes == obj) {
                console.log('lo encontre');
                vie = 'seleccion';
            } else {
                //  vie = 'disponible';
            }

            if (this.calendatioList[i].fechasabado == obj) {
                console.log('lo encontre');
                sab = 'seleccion';
            } else {
                //sab = 'disponible';
            }
          //  console.log('mar ' + mar);
            /* console.log('lun ' + lun);
             console.log('mar ' + mar);
             console.log('mie ' + mie);
             console.log('jue ' + jue);
             console.log('vie ' + vie);
             console.log('sab ' + sab);
             console.log('dom ' + dom);*/
            tmpObj.push({
                id: this.calendatioList[i].id,
                concupoDom: this.calendatioList[i].concupoDom,
                fechadomingo: this.calendatioList[i].fechadomingo,
                diaDomingo: this.calendatioList[i].diaDomingo,
                estadoDom: dom,
                estadoTempDom: this.calendatioList[i].estadoTempDom,


                concupoLun: this.calendatioList[i].concupoLun,
                fechalunes: this.calendatioList[i].fechalunes,
                diaLunes: this.calendatioList[i].diaLunes,
                estadoLun: lun,
                estadoTempLun: this.calendatioList[i].estadoTempLun,

                concupoMar: this.calendatioList[i].concupoMar,
                fechamartes: this.calendatioList[i].fechamartes,
                diaMartes: this.calendatioList[i].diaMartes,
                estadoMar: mar,
                estadoTempMar: this.calendatioList[i].estadoTempMar,

                concupoMie: this.calendatioList[i].concupoMie,
                fechamiercoles: this.calendatioList[i].fechamiercoles,
                diaMiercoles: this.calendatioList[i].diaMiercoles,
                estadoMie: mie,
                estadoTempMie: this.calendatioList[i].estadoTempMie,

                concupoJue: this.calendatioList[i].concupoJue,
                fechajueves: this.calendatioList[i].fechajueves,
                diaJueves: this.calendatioList[i].diaJueves,
                estadoJue: jue,
                estadoTempJue: this.calendatioList[i].estadoTempJue,

                concupoVie: this.calendatioList[i].concupoVie,
                fechaviernes: this.calendatioList[i].fechaviernes,
                diaViernes: this.calendatioList[i].diaViernes,
                estadoVie: vie,
                estadoTempVie: this.calendatioList[i].estadoTempVie,

                concupoSab: this.calendatioList[i].concupoSab,
                fechasabado: this.calendatioList[i].fechasabado,
                diaSabado: this.calendatioList[i].diaSabado,
                estadoSab: sab,
                estadoTempSab: this.calendatioList[i].estadoTempSab
            });


        }

        this.calendatioList = tmpObj;

    }


    @wire(getDetailDataSelected, { fecha: '$searchKey', sala: '$selectedOption', examen: '$idExamen' })
    obtenerDetalle(value) {
        this.wiredActivities = value;
        const { data, error } = value;
        if (data) {
            this.detalleInfo = data;
            this.detalleInfoList =  this.detalleInfo.listaCupos;
            
            //console.log('lista prueba '+this.detalleInfoList[0].diaLunes);
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.detalleInfo = undefined;
        }
    }


    handleAsignarCupo(event) {

        console.log('por aca '+event.target.dataset.id);
        this.cupoSeleccionado = event.target.dataset.id
        this.cambiarColorCupo(event.target.dataset.id);

        return refreshApex(this.wiredActivities);
    }

    cambiarColorCupo(obj) {
        console.log('id cambiar color => ' + obj);
        var i;
        let tmpObj = [];
        for (i = 0; i < this.detalleInfoList.length; i++) {

            var lun = this.detalleInfoList[i].estadoLun;
            if (lun == 'seleccionCupo') {

                lun = 'cupo'
            }
       //     console.log('fecha=> ' + this.detalleInfo.listaCupos[i].idSala);
            if (this.detalleInfoList[i].idSala == obj) {

                //console.log('lo encontre');
                lun = 'seleccionCupo';
            } 
         //   console.log('lun ' + lun);
         
            tmpObj.push({
                diaLunes: this.detalleInfoList[i].diaLunes,
                totLunes: this.detalleInfoList[i].totLunes,
                idSala: this.detalleInfoList[i].idSala,
                estadoLun: lun
            });


        }

        this.detalleInfoList = tmpObj;
     //   this.detail.listaCupos = this.detalleInfoList;
    }

    handleGuardarAsignacion(event){

        guardarCupo({ examen: this.idExamen, sala: this.cupoSeleccionado })
        .then(result => {
           // this.calendatioList = result;
           const toastEvent = new ShowToastEvent({
            title: "El cupo ha sido guardado con éxito",
            variant: "success"
            });
            this.dispatchEvent(toastEvent);

            return refreshApex(this.wiredActivities);
        })
        .catch(error => {
            this.error = error;
        });
    }
    handleSave(event) {

        console.log('guardar ' + event.detail.draftValues[0].Id);

        const recordInputs = event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(contacts => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Cupos actualizados',
                    variant: 'success'
                })
            );
            // Clear all draft values
            this.draftValues = [];
           
            // Display fresh data in the datatable
            return refreshApex(this.wiredActivities);
        }).catch(error => {
            // Handle error
            console.log(error);
            console.log(error.body.message);
            console.log(error.body.output.errors[0].message);
            if (error.body.output.errors[0].message.includes('mayor')) {
                alert(error.body.output.errors[0].message + 'Modificar el valor por uno menor.');
            }
            if (error.body.output.errors[0].message.includes('menor')) {
                alert(error.body.output.errors[0].message + 'Modificar el valor por uno mayor.');
            }

        });
    }

}

function getMonth(params) {
    if (params == '1') {
        return 'Enero';
    }
    if (params == '2') {
        return 'Febrero';
    }
    if (params == '3') {
        return 'Marzo';
    }
    if (params == '4') {
        return 'Abril';
    }
    if (params == '5') {
        return 'Mayo';
    }
    if (params == '6') {
        return 'Junio';
    }
    if (params == '7') {
        return 'Julio';
    }
    if (params == '8') {
        return 'Agosto';
    }
    if (params == '9') {
        return 'Septiembre';
    }
    if (params == '10') {
        return 'Octubre';
    }
    if (params == '11') {
        return 'Noviembre';
    }
    if (params == '12') {
        return 'Diciembre';
    }

}