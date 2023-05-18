import { LightningElement } from 'lwc';

const columns = [
    { label: 'Project Name', fieldName: 'name' },
    { label: 'Task Name', fieldName: 'taskName' },
    { label: 'State', fieldName: 'state' },
    { label: 'Estimated Hours', fieldName: 'EstimatedHours', type: 'number' },
    { label: 'Registered Hours', fieldName: 'RegisteredHours', type: 'number' },
];

const projects = [
    {
        name: 'Proyecto Rompe bytes',
        tareas: [
            {
                taskName: 'Crear Modelo de Datos',
                state: 'In Progress',
                EstimatedHours: 34,
                RegisteredHours: 12,
                init:true,
                id:1
            },
            {
                taskName: 'Armado de reportes',
                state: 'No init',
                EstimatedHours: 25,
                RegisteredHours: 0,
                init:false,
                id:2
            },
            {
                taskName: 'Configurar Perfiles',
                state: 'No init',
                EstimatedHours: 12,
                RegisteredHours: 0,
                init:false,
                id:3
            }
        ]
    },
    {
        name: 'Proyecto Innovar',
        tareas: [
            {
                taskName: 'Crear Validation Rules',
                state: 'In Progress',
                EstimatedHours: 20,
                RegisteredHours: 8,
                init:true,
                id:4
            },
            {
                taskName: 'Apex Trigger Position',
                state: 'No init',
                EstimatedHours: 40,
                RegisteredHours: 0,
                init:false,
                id:5
            }
        ]
    },
];

export default class AssignmentHours extends LightningElement {
    columns = columns;
    projects = projects;
    registeredHours;

    // Metodo que al hacer click sobre el boton Iniciar captura el id de la task.
    handleClickInit(event){
        const taskId = event.target.dataset.id;
        this.searchTaskById(taskId)
    }

    searchTaskById(id) {
        projects.forEach(project => {
          project.tareas.forEach(task => {
            if(task.id == id){
                console.log(JSON.stringify(task));
            }
          })
        });
    }
      

    //Metodo que me trae el registro/objeto task que pido por ID.
    // --------------------------------------------------------------------------------------
  

    //--- handleChange se encarga de capturar el valor de las horas registradas, para almacenarlas en una propiedad/variable de la clase. ---

    handleChange(event){
        this.registeredHours = event.target.value;
        console.log(this.registeredHours)
    }
}