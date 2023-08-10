import { LightningElement, api } from 'lwc';
import CMEXSelfServiceStepComponentInfo from '@salesforce/label/c.CMEXSelfServiceStepComponentInfo';
import CMEXSelfServiceStepComponentStep1 from '@salesforce/label/c.CMEXSelfServiceStepComponentStep1';
import CMEXSelfServiceStepComponentStep2 from '@salesforce/label/c.CMEXSelfServiceStepComponentStep2';
import CMEXSelfServiceStepComponentStep3 from '@salesforce/label/c.CMEXSelfServiceStepComponentStep3';
export default class b2bSelfServiceChangeState extends LightningElement {
    label = {
        CMEXSelfServiceStepComponentInfo
    };

    stepList = [
        {
            name: CMEXSelfServiceStepComponentStep1,
            sequence: 1
        },
        {
            name: CMEXSelfServiceStepComponentStep2,
            sequence: 2
        },
        {
            name: CMEXSelfServiceStepComponentStep3,
            sequence: 3
        }
    ]

    @api currentStep=2;

    connectedCallback() {
        this.stepList.map(step => {
            var done;
            var className;
            var isCurrentStep;
            if (step.sequence < this.currentStep) {
                done = true;
                className = 'step';
            }
            else if (step.sequence === this.currentStep) {
                done = false;
                className = 'step current-step';
                isCurrentStep = true;
            }
            else {
                done = false;
                className = 'step';
            }

            step['done'] = done;
            step['className'] = className;
            step['isCurrentStep'] = isCurrentStep;
        });
        this.stepList[this.stepList.length-1]['isLast']=true;
        console.log(this.stepList);
    }

}