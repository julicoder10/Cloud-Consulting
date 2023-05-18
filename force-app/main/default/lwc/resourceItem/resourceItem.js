import {LightningElement, api, track} from 'lwc';

export default class ResourceItem extends LightningElement {

	@api resource;
	@api projectItem;
	@api resourceRol;
	@api projectRol;

	disabledStartDate;
	disabledEndDate;
	disabledAssignedHours;
	valueCheckbox;
	@track valueStartDate;
	valueEndDate;
	valueAssignedHours;

	@api resourceProject;

	constructor() {
		super();
		this.disabledStartDate = true;
		this.disabledEndDate = true;
		this.disabledAssignedHours = true;
		this.valueStartDate = '';
		this.valueEndDate = '';
		this.valueAssignedHours = 0;
		this.valueCheckbox = false;
		this.resourceProject = {};
	}

	get isEqualRol() {
		return this.resourceRol == this.projectRol;
	}

	handleChangeCheckbox(event) {
		this.valueCheckbox = event.target.checked;
		console.log(event.target.checked);
		this.disabledStartDate = !this.disabledStartDate;
		this.disabledEndDate = !this.disabledEndDate;
		this.disabledAssignedHours = !this.disabledAssignedHours;
	}

	isValidStartDate(_valueStartDate) {
		const projectStartDate = this.projectItem.Project__r.Project_Start__c;
		const projectEndDate = this.projectItem.Project__r.Project_End__c;
		return projectStartDate <= _valueStartDate && _valueStartDate <= projectEndDate;
	}

	get MaxAssignedHours() {
		let hoursToCover;
		let quantity = this.projectItem.Quantity__c;
		if (this.projectItem.Rol__c === 'Architect') {
			hoursToCover = quantity - this.projectItem.Project__r.QuantityHourArchitect__c;
		} else if (this.projectItem.Rol__c === 'Developer') {
			hoursToCover = quantity - this.projectItem.Project__r.QuantityHourDeveloper__c;
		} else {
			hoursToCover = quantity - this.projectItem.Project__r.QuantityHourConsult__c;
		}
		return hoursToCover;
	}

	handleChangeStartDate(event) {
		const _valueStartDate = event.target.value;
		this.valueStartDate = _valueStartDate;
	}

	handleChangeEndDate(event) {
		const _valueEndDate = event.target.value;
		event.target.setCustomValidity("");

		if (this.valueStartDate <= _valueEndDate) {
			this.valueEndDate = _valueEndDate;
		} else {
			event.target.setCustomValidity("the end date must be greater than equal to start date");
			event.target.reportValidity();
		}
	}

	handleChangeAssignedHours(event) {
		let inputNumber = event.target;
		inputNumber.setCustomValidity('');

		if (inputNumber.value > inputNumber.max) {
			inputNumber.setCustomValidity('Hours to cover must be less than equal to ' + inputNumber.max);
			inputNumber.reportValidity();
		}

		this.valueAssignedHours = inputNumber.value;
		console.log(this.template);
		console.log(this);
	}

	@api
	validationItem() {
		if (this.valueCheckbox) {
			if (this.valueStartDate && this.valueEndDate && this.valueAssignedHours) {
				this.resourceProject.Name = this.resource.Name;
				this.resourceProject.Start_Date__c = this.valueStartDate;
				this.resourceProject.End_Date__c = this.valueEndDate;
				this.resourceProject.Rol__c = this.projectItem.Rol__c;
				this.resourceProject.Project__c = this.projectItem.Project__c;
				this.resourceProject.User__c = this.resource.Id;
				this.resourceProject.Assigned_Hours__c = this.valueAssignedHours;
			}
		}
	}

}