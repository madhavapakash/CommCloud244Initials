import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin'


export default class ARTL_ClickToCall extends OmniscriptBaseMixin(LightningElement) {
    @api recordId;

    // connectedCallback(){
    //     var jsonData = {
    //         ContextId: this.recordId,
    //         processName: "ClickToCall"
    //     };
    //     console.log('jsonData ', jsonData);
    //     console.log(JSON.stringify({ "ContextId": this.recordId, "processName": "ClickToCall" }));
    //     return JSON.stringify({ "ContextId": this.recordId});//, "processName": "ClickToCall" });
    // }
    get prefill() {
        //return '{"ContextId":"' + this.recordId + '","processName":"ClickToCall"}';
        
        console.log(JSON.stringify({ "ContextId": this.recordId, "processName": "ClickToCall" }));
        return JSON.stringify({ "ContextId": this.recordId, "processName": "ClickToCall" });
    }
}