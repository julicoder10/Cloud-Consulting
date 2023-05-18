import { LightningElement, api, wire, track } from 'lwc';
import getProject from "@salesforce/apex/ProfitReport.getProject";
import {refreshApex} from '@salesforce/apex'

export default class ProfitReport extends LightningElement {
	
	@api recordId;
	@track percentage;
	wireProject

	@wire(getProject, { projectId: '$recordId' })
	_getProject(result) {
		this.wireProject = result;
		if (result.data) {
			this.percentage = result.data.Win_or_Lose__c;
			this.error = undefined;
		} else {
			this.percentage = undefined;
			this.error = result.error;
		}
	}

	get isProfit() {
		refreshApex(this.wireProject);
		return this.percentage >= 0;
	}

}