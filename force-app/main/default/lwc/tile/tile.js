import { LightningElement, api } from 'lwc';

import Card from '@salesforce/resourceUrl/Card';

export default class Tile extends LightningElement {
	@api Project__c;

	appResources = {
		projectSilhouette: `${Card}`,
	};

    handleOpenRecordClick() {

        const selectEvent = new CustomEvent('projectview', {
            detail: this.Project__c.Id
        });

        this.dispatchEvent(selectEvent);
    }
}