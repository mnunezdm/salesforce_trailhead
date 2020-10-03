import { LightningElement, wire, api, track } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';

import { publish, MessageContext } from 'lightning/messageService';
import { refreshApex } from '@salesforce/apex';

import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';

import getBoats from '@salesforce/apex/BoatDataService.getBoats';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT = 'Ship it!';
const SUCCESS_VARIANT = 'success';
const ERROR_TITLE   = 'Error';
const ERROR_VARIANT = 'error';

export default class BoatSearchResults extends LightningElement {
  selectedBoatId;
  columns = [
    { fieldName: 'Name', label: 'Name', type: 'text', editable: true, },
    { fieldName: 'Length__c', label: 'Length', type: 'number', editable: true, },
    { fieldName: 'Price__c', label: 'Price', type: 'currency', editable: true, },
    { fieldName: 'Description__c', label: 'Description', type: 'text', editable: true, },
  ];
  boatTypeId = '';
  @track boatTrack;
  @track boats = [];
  isLoading = false;

  draftValues = [];

  // wired message context
  @wire(MessageContext)
  messageContext;

  @wire(getBoats, { boatTypeId: '$boatTypeId' })
  wiredBoats(boats) {
      this.boatTrack = boats;
      this.boats = boats.data || [];
      if (boats.error) {
          this.error = boats.error;
      }
      this.isLoading = false;
      this.notifyLoading(this.isLoading);
  }

  // public function that updates the existing boatTypeId property
  // uses notifyLoading
  @api
  searchBoats(boatTypeId) {
    this.boatTypeId = boatTypeId;
    this.notifyLoading(true);
  }

  // this public function must refresh the boats asynchronously
  // uses notifyLoading
  @api async refresh() {
    this.notifyLoading(true);
    await refreshApex(this.boatTrack);
    this.notifyLoading(false);
  }

  /**
   * this function must update selectedBoatId and call sendMessageService
   * @param {CustomEvent} event
   */
  updateSelectedTile(event) {
    this.selectedBoatId = event.detail.boatId;
    this.sendMessageService(this.selectedBoatId);
  }

  /**
   * Publishes the selected boat Id on the BoatMC.
   * @param {String} boatId
   */
  sendMessageService(boatId) {
    // explicitly pass boatId to the parameter recordId
    const message = {
      recordId: boatId,
    };
    publish(this.messageContext, BOATMC, message);
  }

  // This method must save the changes in the Boat Editor
  // Show a toast message with the title
  // clear lightning-datatable draft values
  handleSave(event) {
    const recordInputs = event.detail.draftValues
      .slice()
      .map(draft => {
        const fields = Object.assign({}, draft);
        return { fields };
      });
    const promises = recordInputs
      .map(recordInput => updateRecord(recordInput) );

    Promise.all(promises)
        .then(() => {
          const toast = new ShowToastEvent({
            title: SUCCESS_TITLE,
            message: MESSAGE_SHIP_IT,
            variant: SUCCESS_VARIANT,
          });
          this.dispatchEvent(toast);
          this.draftValues = [];
          this.refresh();
        })
        .catch(error => {
          const toast = new ShowToastEvent({
            title: ERROR_TITLE,
            message: error,
            variant: ERROR_VARIANT,
          });
          this.dispatchEvent(toast);
        })
        .finally(() => {});
  }

  // Check the current value of isLoading before dispatching the doneloading or loading custom event
  notifyLoading(isLoading) {
    if (isLoading) {
      this.dispatchEvent(new CustomEvent('loading'));
    } else {
      this.dispatchEvent(new CustomEvent('doneloading'));
    }
  }
}