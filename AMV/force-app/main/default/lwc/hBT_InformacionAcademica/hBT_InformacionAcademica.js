import { LightningElement, track, wire, api } from 'lwc';
import getInfoAcademica from '@salesforce/apex/HBT_InformacionAcademicaHelper.getInfoAcademica';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getInstitucion from '@salesforce/apex/HBT_InformacionAcademicaHelper.getInstitucion';
import obtenerInformacionProfesional from '@salesforce/apex/HBT_InformacionProfesionalHelper.getAvanceContacto';
import { refreshApex } from '@salesforce/apex';
import actualizarAplica from '@salesforce/apex/HBT_InformacionProfesionalHelper.actualizarAplica';



export default class HBT_InformacionAcademica extends LightningElement {
  @track bShowModal = false;
  @api recordId;
  @track wiredActivities;
  @track wiredActivities2;
  @track activarAplica = true;
  desactivado = false;
  formacion = "";
  activarCampoCursos = false;
  activarCamposNacional = false;
  activarCampoInternal = false;
  activarCampoOtraInstitucion = false;
  activarFormacionGrande = true;
  activarFormacionPeque = false;  
  activarNivelEstudio = false;
  activarPais = false;
  activarCiudad = false;
  activarInstitucion = false;
  activarCarrera = false;
  activarTipoCurso = false;
  activarEstado = false;
  activarNombreCurso = false;
  activarFechaTerminacion = false;

  @track profesional;
  @track activarTodo;
  @track arregloAux = [];
  @track error;
  accList = [];
  @track arregloInicial=[];
  /**
   * Metodo que actualiza el campo de No aplica de la parte superior
   */
  activarAcademica() {
    this.activarTodo = this.activarTodo ? false : true;
    actualizarAplica({ campoAplica: this.activarTodo, tipo: 'academica' })
      .then(data => { 
        return refreshApex(this.wiredActivities2)
      })
      .catch(error => {
        console.log("Error", error);

      });


  }
  /**
   * Metodo que obtiene la informacion del profesional
   */
  @wire(obtenerInformacionProfesional)
  wiredProfesional(value) {
    this.wiredActivities2 = value;
    const { data, error } = value;
    if (data) {
      this.profesional = data[0].Id;
      this.activarTodo = data[0].Informacion_academica__c;

    } else if (error) {
      console.log("Error", error);

    }
  }
  /**
   * Metodo que activa e inactiva los campos segun el tipo de formacion seleccionada
   */
  cambiarFormacion(event) {

    this.activarFormacionGrande = false;
    this.activarFormacionPeque = true;
    this.activarCarrera = true;
    this.activarNivelEstudio = true;
    this.activarPais = false;
    this.activarCiudad = true;
    this.activarInstitucion = true;
    this.activarTipoCurso = false;
    this.activarEstado = true;
    this.activarNombreCurso = false;
    this.activarFechaTerminacion = true;
    this.arregloAux[event.target.name].carrera1=true;
    this.arregloAux[event.target.name].nivel=true;
    this.arregloAux[event.target.name].pais=false;
    this.arregloAux[event.target.name].ciudad=true;
    this.arregloAux[event.target.name].tipoCurso=false;
    this.arregloAux[event.target.name].estado=true;
    this.arregloAux[event.target.name].nombreCurso=false;
    this.formacion = event.target.value;
    if (this.formacion === 'Cursos') {
      this.activarNivelEstudio = false;
      this.arregloAux[event.target.name].nivel=false;
      this.activarCarrera = false;
      this.arregloAux[event.target.name].carrera1=false;
      this.activarTipoCurso = true;
      this.arregloAux[event.target.name].tipoCurso=true;
      this.activarEstado = false;
      this.arregloAux[event.target.name].estado=false;
      this.activarCampoCursos=true;
      this.activarNombreCurso = true;
      this.arregloAux[event.target.name].nombreCurso=true;
      this.activarCamposNacional=false;
      this.activarCampoInternal=false;
    } else if (this.formacion === 'Internacional') {
      this.activarPais = true;
      this.arregloAux[event.target.name].pais=true;
      this.activarCiudad = false;
      this.arregloAux[event.target.name].ciudad=false;
      this.activarCampoInternal=true;
      this.activarNombreCurso = false;
      this.activarCamposNacional=false;
    }
    else if (this.formacion === 'Nacional') {
      this.activarCampoInternal=false;
      this.activarNombreCurso = false;
      this.activarCamposNacional=true;
    }
    else {
      this.setearCampos();
    }
  }
  setearCampos(){
    this.activarFormacionGrande = true;
    this.activarFormacionPeque = false;
    this.activarNivelEstudio = false;
    this.activarPais = false;
    this.activarCiudad = false;
    this.activarInstitucion = false;
    this.activarCarrera = false;
    this.activarTipoCurso = false;
    this.activarEstado = false;
    this.activarNombreCurso = false;
    this.activarFechaTerminacion = false;
    this.activarCampoInternal=false;
    this.activarNombreCurso = false;
    this.activarCamposNacional=false;
  }



  /**
   * Metodo que trae el Id de la institucion OTRA para habilitar campo de otra institucion
   */
  encontrarValorInstitucion(event) {
    this.institucion = event.target.value;
    getInstitucion({

    })
      .then(institucion => {
        if (institucion.Id === this.institucion) {
          this.activarCampoOtraInstitucion = true;
          this.arregloAux[event.target.name].institucion=true;

        } else {
          this.activarCampoOtraInstitucion = false;
          this.arregloAux[event.target.name].institucion=false;

        }
      })
      .catch(error => {
        console.log(error);
      });

  }

  encontrarValorInstitucionInicial(idInstitucion) {
    this.institucion = idInstitucion;
    getInstitucion({

    })
      .then(institucion => {
        if (institucion.Id === this.institucion) {
          return true;

        } else {
           return false;
        }
      })
      .catch(error => {
        console.log(error);
      });
      return false;

  }
  /**
   * Metodo que muestra un mensaje de exito al usuario cuando crea un registro
   */
  exito(event) {
    const toastEvent = new ShowToastEvent({
      title: "Información laboral guardada",
      variant: "success"
    });
    this.dispatchEvent(toastEvent);
    this.bShowModal = false;
    this.setearCampos();
    refreshApex(this.wiredActivities2);
    return refreshApex(this.wiredActivities);


  }
  /**
   * Metodo que activa la variable que se selecciona en el acordeon
   */
  editar(event) {
    this.activarAcordeon(parseInt(this.covertirId(event.target.id)));
    for (let i = 0; i < this.arregloAux.length; i++) {
      if (i === parseInt(this.covertirId(event.target.id))) {
        this.arregloAux[i].activar = false;
      } else {
        this.arregloAux[i].activar = true;

      }
    }
  }

 /**
  * Metodo que activa una seccion del acordeon segun el nombre ingresado
  */
  activarAcordeon(nombre) {
    const accordion = this.template.querySelector('.claseAcordeon');
    accordion.activeSectionName = nombre;
  }
  /**
   * Metodo que cancela la edicion de todo el acordeon
   */
  editarFalso() {
    this.arregloAux=this.arregloInicial;
    for (let i = 0; i < this.arregloAux.length; i++) {
      this.arregloAux[i].activar = true;
    }
 
  }
  /**
   * Metodo que le quite al Id una seccion sobrante
   *  */ 
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
  /**
   * Metodo que abre el modal para crear la informacion academica
   */
  activarCrear() {
    this.bShowModal = true;
  }
  /**
   * Metodo que cierra el modal y setea el valor de las variables a su estado inicial
   */
  desactivarCrear() {
    this.bShowModal = false;
    this.setearCampos();
  }
/**
 * Metodo que convierte a un nivel educativo de su valor entero a su valor correspondiente
 */
  crearNivelEducativo(numero) {
    if (numero === '1') {
      return 'Pregrado';
    } else if (numero === '2') {
      return 'Posgrado'
    }
    else if (numero === '236') {
      return 'Técnico'
    }
    else if (numero === '24') {
      return 'Doctorado'
    }
    else if (numero === '25') {
      return 'Maestría'
    }
    else if (numero === '6') {
      return 'Tecnológico'
    }
    else if (numero === '385') {
      return 'Otros estudios'
    }

  }
  /**
   * Metodo que separa el arreglo por atributos
   */
  convertirLista() {
    this.arregloAux = [];
    for (let i = 0; i < this.accList.length; i++) {

      this.arregloAux.push({
        Id: this.accList[i].Id,
        activar: true,
        carrera: this.accList[i].Carrera__r != undefined ? this.crearNivelEducativo(this.accList[i].Nivel_estudio__c) 
        + " " + this.accList[i].Carrera__r.Name : this.accList[i].Formacion_academica__c + " " + this.accList[i].Nombre_curso__c,
        nivel: this.accList[i].Formacion_academica__c === 'Cursos'?false: true,
        pais: this.accList[i].Formacion_academica__c === 'Internacional'?true: false,
        ciudad: this.accList[i].Formacion_academica__c === 'Internacional'?false: true,
        carrera1: this.accList[i].Formacion_academica__c === 'Cursos'?false: true,
        tipoCurso: this.accList[i].Formacion_academica__c === 'Cursos'?true: false,
        estado:this.accList[i].Formacion_academica__c === 'Cursos'?false: true,
        nombreCurso:this.accList[i].Formacion_academica__c === 'Cursos'?true: false,
        institucion: this.encontrarValorInstitucionInicial(this.accList[i].Institucion_academica__c)

      })
      //
    }
    this.arregloInicial=this.arregloAux;

  }



  /**
   * Metodo que obtiene la informacion academica del Helper
   */
  @wire(getInfoAcademica)
  wiredInformacionAcademica(value) {
    this.wiredActivities = value;
    const { data, error } = value;
    if (data) {
      this.accList = data;
      this.convertirLista();
      if (this.accList.length > 0) {
        this.activarAplica = false;
      }

    } else if (error) {
      this.error = error;
    }
  }
}