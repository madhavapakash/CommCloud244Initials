import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin'


export default class ARTL_LeadConversion extends OmniscriptBaseMixin(LightningElement)  {
    @api recordId;
    get prefill() {
        return JSON.stringify({ "ContextId": this.recordId});
    }
}