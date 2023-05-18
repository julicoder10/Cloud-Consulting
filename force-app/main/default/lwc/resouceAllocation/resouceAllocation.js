import {LightningElement, wire, api} from 'lwc';
import getResources from '@salesforce/apex/ControllerResourceAllocation.getResources';
import getProjectItems from '@salesforce/apex/ControllerResourceAllocation.getProjectItems'
import createResourceProjects from '@salesforce/apex/ControllerResourceAllocation.createResourceProjects'
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex'

export default class ResouceAllocation extends LightningElement {

	@api
	recordId;
	resources;
	projectItems;

	wireResources;
	wireProjectItems;

	@wire(getResources, {projectId: '$recordId'})
	_getResources(result) {
		this.wireResources = result;
		if (result.data) {
			this.resources = result.data;
			this.error = undefined;
		} else {
			this.error = result.error;
			this.resources = undefined;
		}
	}

	@wire(getProjectItems, {projectId: '$recordId'})
	_getProjectItems(result) {
		this.wireProjectItems = result;
		if (result.data) {
			this.projectItems = result.data;
			this.error = undefined;
		} else {
			this.error = result.error;
			this.projectItems = undefined;
		}
	}

	//get isNotEndedProyect() {
	//	let currentDate = new Date().toJSON().slice(0, 10);
	//	let endProject = this.projectItems[0].Project__r.Project_End__c;
	//	console.log(endProject >= currentDate);
	//	return endProject >= currentDate;
	//}

	handleClick(event) {
		event.preventDefault();
		const resourceItems = this.template.querySelectorAll('c-resource-item')
		const resourceProjects = [];

		resourceItems.forEach(resourceItem => {
			resourceItem.validationItem();
			if (Object.keys(resourceItem.resourceProject).length != 0) {
				resourceProjects.push(resourceItem.resourceProject);
			}
		});

		const _jsonResourceProjects = JSON.stringify(resourceProjects);

		if (resourceProjects.length > 0) {
			this.insertResourceProjects(_jsonResourceProjects);
		} else {
			this.insertFail();
		}
	}

	insertResourceProjects(_jsonResourceProjects) {
		console.log(_jsonResourceProjects);
		window.clearTimeout(this.delayTimeout);
		createResourceProjects({jsonResourceProjects: _jsonResourceProjects})
			.then(() => {
				const toastEvent = new ShowToastEvent({
					title: 'Successfull',
					message: 'Assigned Hours to Project',
					variant: 'success',
				});
				this.dispatchEvent(toastEvent);
			})
			.catch((error) => console.log(error));

		setTimeout(() => {
			refreshApex(this.wireResources);
			refreshApex(this.wireProjectItems);
			location.reload()
		}, 3000);
	}

	insertFail() {

		const toastEvent = new ShowToastEvent({
			title: 'Warning',
			message: 'You must to Assigned at least one User',
			variant: 'warning',
		});
		this.dispatchEvent(toastEvent);
	}
}