import { LightningElement, api } from 'lwc';

export default class ChartBar extends LightningElement {
	@api percentage;
	@api isProfit;

    get style() {
        return `width: ${this.percentage}%`;
    }
}