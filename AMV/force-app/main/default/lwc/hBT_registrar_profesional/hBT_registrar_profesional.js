import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import getAmvAccountId from '@salesforce/apex/HBT_RegistrarProfesionalController.getAmvAccountId';
import enableCustomerUser from '@salesforce/apex/HBT_RegistrarProfesionalController.enableCustomerUser';
import getURLTC from '@salesforce/apex/HBT_RegistrarProfesionalController.getURLTC';
import logoAMV from '@salesforce/resourceUrl/HBT_LogoAMV';


export default class HBT_registrar_profesional extends LightningElement {
    @api objectApiName;
    @api recordId;
    @track bShowModal = false;
    @track bShowModalNotificacion = false;
    @track nombre1;
    @track nombre2;
    @track apellido1;
    @track apellido2;
    @track idDireccionResidencia;
    @track idDireccionNotificacion;
    @track idDCreado;
    @track urlData;
    @track mensajeErrorEncontrado;
    @track mostrarNotificacion;
    profesionalRecordTypeId;
    accountId;
    complemento1;
    complemento2;
    valorNotificacion;
    sfdcBaseURL;
    idPrueba = "";
    tipoTC = 'Hoja de vida';
    imglogo = logoAMV;



    @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
    obtenerInformacionContacto({ error, data }) {
        if (data) {
            this.sfdcBaseURL = window.location.origin + '/Profesionales/hbt_loginprofesional';

            let mapaRecordTypes = data.recordTypeInfos;
            console.log(mapaRecordTypes);
            for (let recordTypeId in mapaRecordTypes) {
                if (mapaRecordTypes[recordTypeId].name === 'Profesional') {
                    this.profesionalRecordTypeId = recordTypeId;
                }
            }




        }



        else if (error) {
            // TODO: manejar error
        }


    }

    @wire(getAmvAccountId, {})
    obtenerAmvAccountId({ error, data }) {
        if (data) {
            this.accountId = data;

            var ip = location.host;
            console.log('otra ip ' + ip);
        }
        else if (error) {
            // TODO: manejar error
        }
    }

    @wire(getURLTC, {})
    getURLTC({ error, data }) {
        if (data) {
            this.urlData = data;
        }
        else if (error) {
            // TODO: manejar error
        }
    }

    handleComplementoChange(event) {
       // alert(event.target.value);
        this.complemento1 = event.target.value;
    }

    handleComplemento2Change(event) {
        // alert(event.target.value);
         this.complemento2 = event.target.value;
     }

    handleCheckBoxChange(event){
     //   alert(event.target.checked);
     this.valorNotificacion = event.target.checked;
        if(event.target.checked == true){
            this.mostrarNotificacion = 'true';
        }else{
            this.mostrarNotificacion = '';
        }
       
    }

    handleSubmitNewContact(event) {


        console.log('voy a guardar el profesional ');
        this.mensajeErrorEncontrado = '';

    }

    handleContactCreationSuccessful(event) {
        console.log('Creación exitosa');
        this.idDCreado = event.detail.id;

        enableCustomerUser({ id: this.idDCreado })
            .then(() => {
                console.log('Customer user habilitado');
            })
            .catch(error => {
                console.log('Fallo al intentar habilitar Customer user');
            });
    }



    showToast(title, message, variantStr) {
        /*   new ShowToastEvent({
               title: title,
               message: message,
               variant: variantStr
           });*/
        //  this.dispatchEvent(event);

    }

    handleErrorOnContactCreation(event) {
        console.log('Creación fallida: ' + event.detail);

        if ((event.detail.detail).includes('duplicate value found')) {

            this.mensajeErrorEncontrado = 'Ya existe un profesional con el mismo número de documento, por favor intentelo de nuevo con un valor diferente.';
        } else {
            if ((event.detail.detail).includes('Debe agregar una dirección valida')) {
                this.mensajeErrorEncontrado = 'Es necesario agregar un valor valido para la Dirección de residencia. Hagalo a través del botón correspondiente.';
            } else {
                this.mensajeErrorEncontrado = 'Se ha presentado un error.';
            }
        }
        console.log(JSON.stringify(event.detail));
        /*    this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Cración fallida',
                    message: "La creacion del Contacto fallo.",
                    variant: 'error'
                }),
            );*/
    }

    handleSuccessResidencia(event) {
        console.log("creado objeto " + event.detail.id);
        this.idDireccionResidencia = event.detail.id;
        this.closeModal();
    }

    handleSuccessNotifcacion(event) {
        console.log("creado objeto " + event.detail.id);
        this.idDireccionNotificacion = event.detail.id;
        this.closeModalNotificacion();
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
    /* javaScipt functions end */

    openModalNotificacion() {
        // to open modal window set 'bShowModal' tarck value as true
        this.bShowModalNotificacion = true;
    }

    closeModalNotificacion() {
        // to close modal window set 'bShowModal' tarck value as false
        this.bShowModalNotificacion = false;
    }
    /* javaScipt functions end */

}
/*function getIPAddress()
{
    var ip = location.host;
    console.log('otra ip '+ip);
    var request = new XMLHttpRequest();
    request.open('GET', "https://api.ipify.org?format=jsonp=", true);
    request.onload = function () {
        console.log(request.status);
        if (request.status >= 200 && request.status < 400) {
            let ipAddress = request.responseText;
            //  document.getElementById('{!$Component.apForm.ipvalor}').value =ipAddress;
            console.log('funcion js: '+ipAddress);
           // return request.responseText;
        } else {
            // We reached our target server, but it returned an error
            console.log(request.statusText);
        }
    }
    request.onerror = function () {
        // There was a connection error of some sort
        console.log(request.statusText);
    }
    request.send();

    return request.responseText;
}*/