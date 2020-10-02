import { LightningElement, track, wire } from 'lwc';

import getBoatTypes from '@salesforce/apex/BoatDataService.getBoatTypes';

export default class BoatSearchForm extends LightningElement {
  selectedBoatTypeId = '';

  // Private
  error = undefined;

  // Needs explicit track due to nested data
  @track
  searchOptions;

  // Wire a custom Apex method
  @wire(getBoatTypes)
  boatTypes({ error, data }) {
    console.log(data);
    if (data) {
      this.searchOptions = data.map(type => ({
        value: type.Id,
        label: type.Name,
      }));
      this.searchOptions.unshift({ label: 'All Types', value: '' });
    } else if (error) {
      this.searchOptions = undefined;
      this.error = error;
    }
  }

  // Fires event that the search option has changed.
  // passes boatTypeId (value of this.selectedBoatTypeId) in the detail
  handleSearchOptionChange(event) {
    // Create the const searchEvent
    // searchEvent must be the new custom event search
    this.selectedBoatTypeId = event.detail.value;

    this.dispatchEvent(new CustomEvent('search', {
      detail: {
        boatTypeId: this.selectedBoatTypeId,
      }
    }));
  }
}