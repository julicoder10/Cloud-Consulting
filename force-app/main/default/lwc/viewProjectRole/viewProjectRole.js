import { LightningElement, api } from 'lwc';

export default class ViewProjectRole extends LightningElement {

  @api projectItem;

  get hoursToCover() {
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
}