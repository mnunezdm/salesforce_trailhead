import { LightningElement, wire, api } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';

// imports
import getSimilarBoats from '@salesforce/apex/BoatDataService.getSimilarBoats';

export default class SimilarBoats extends NavigationMixin(LightningElement) {
  // Private
  currentBoat;
  relatedBoats;
  boatId;
  error;

  @api
  get recordId() {
    // returns the boatId
    return this.boatId;
  }
  set recordId(value) {
    // sets the boatId value
    // sets the boatId attribute
    this.setAttribute('boatId', value);
    this.boatId = value;
  }

  @api
  similarBy;

  // Wire custom Apex call, using the import named getSimilarBoats
  // Populates the relatedBoats list
  @wire(getSimilarBoats, { boatId: '$boatId', similarBy: '$similarBy' })
  similarBoats({ error, data }) {
    if (error) {
      this.error = error;
    }
    if (data) {
      this.relatedBoats = data;
    }
  }

  get getTitle() {
    return 'Similar boats by ' + this.similarBy;
  }
  get noBoats() {
    return !(this.relatedBoats && this.relatedBoats.length > 0);
  }

  // Navigate to record page
  openBoatDetailPage(event) {
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: event.detail.boatId,
        objectApiName: 'Boat__c',
        actionName: 'view',
      },
    });
  }
}