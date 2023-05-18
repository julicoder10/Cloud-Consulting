import { LightningElement, wire} from 'lwc';
import getResourceProjects from '@salesforce/apex/AsignedTaskController.getResourceProjects';
import {updateRecord} from 'lightning/uiRecordApi';

import STATUS_FIELD from '@salesforce/schema/Assigment_Task__c.Status__c';
import REPORTEDHOURS_FIELD from '@salesforce/schema/Assigment_Task__c.ReportedHours__c';

export default class CargaHoras extends LightningElement {

    // Creamos una variable/propiedad llamada resourceProjects.

    resourceProjects;

    // Usamos un wire para conectarnos a un metodo de APEX, para poder traernos la data (resourceProjects).

	@wire(getResourceProjects)
	_getResourceProjects({data, error}) {
		if (data) {
			this.resourceProjects = data;
			console.log("data: " + data);
		} else {
			console.log("error: " + error);
		}
	}

    // Almacenar el ID de la task INICIADA.

    selectedTaskId;

    // Metodo que al hacer click sobre el boton Iniciar captura el id de la task.
    handleClickStart(event){
        this.selectedTaskId = event.target.dataset.id;
        this.handleUpdate();
    }

    // Metodo que actualiza el estado de la tarea de "Not Init" a "In Progress".

    handleUpdate() {
        const fields = {};
        fields[STATUS_FIELD.fieldApiName] = 'In Progress';
        
        // Este recordInput sería el objeto (Registro) que actualiza la DB.
        const recordInput = { fields };

        recordInput.recordId = this.selectedTaskId;

        updateRecord(recordInput)
            .then(() => {
            	// pruebo con location.reload()
                window.location.reload()
            })
            .catch(error => {
                console.log(error)
            });
    }

    registeredHours;

    handleChange(event){
        this.registeredHours = event.target.value;
    }

    // Metodo que toma las horas capturadas por el metodo handleChange ( metodo que toma valor (value) de input al escribir)
    // este metodo invoca al metodo handleAddRegisteredHoursUpdate pasandole como argumentos el id de la tarea y las horas reportadas
    // hasta el momento.

    handleClickRegisterHours(event){
        let hoursUpToNow = event.target.dataset.reportedhours;
        const taskId = event.target.dataset.id;

        if(hoursUpToNow === undefined){
            hoursUpToNow = 0;
        }

        this.handleAddRegisteredHoursUpdate(hoursUpToNow, taskId);
    }

    // Este metodo se encarga de hacer la suma de las horas registras hasta el momento, más las horas que le queremos agregar
    // Generando una suma, esa suma se agrega en el status (campo/field) y agregamos el ID de la tarea para especificarle al updateRecord
    // que registro debe actualizar (hacer un update en DB).

    handleAddRegisteredHoursUpdate(reportedHoursNow, identifier){
        const fields = {};
        const sum = Number(reportedHoursNow) + Number(this.registeredHours);
        
        fields[REPORTEDHOURS_FIELD.fieldApiName] = sum;
        
        // Este recordInput sería el objeto que le dice a la DB que registro(identifier) debe actualizar y qué campos 
        //modificar(fields).

        const recordInput = { fields };

        recordInput.recordId = identifier;

        updateRecord(recordInput)
            .then(() => {
                window.location.reload()
            })
            .catch(error => {
                console.log(error)
            });
    }

    // Metodo que toma los valores necesarios para hacer la actualizacion del status de la task a "Completed"
    
    handleClickCompleted(event){
        const status = event.target.dataset.status;
        const taskId = event.target.dataset.id;
        if(status !== 'Completed'){
            this.handleStatusCompletedUpdate(taskId);
        }   
    }

    //Este metodo hace el update a "Completed" del campo Status__c.

    handleStatusCompletedUpdate(taskId) {
        const fields = {};
        fields[STATUS_FIELD.fieldApiName] = 'Completed';
        
        // Este recordInput sería el objeto (Registro) que actualiza la DB.
        const recordInput = { fields };

        recordInput.recordId = taskId;

        updateRecord(recordInput)
            .then(() => {
                window.location.reload()
            })
            .catch(error => {
                console.log(error)
            });
    }
}