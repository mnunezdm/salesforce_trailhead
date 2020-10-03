import { LightningElement, api } from 'lwc';

import { loadScript, loadStyle } from 'lightning/platformResourceLoader';

//import fivestar static resource, call it fivestar
import fivestar from '@salesforce/resourceUrl/fivestar';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// add constants here
const ERROR_TITLE = 'Error loading five-star';
const ERROR_VARIANT = 'error';
const READ_ONLY_CLASS = 'readonly c-rating';
const EDITABLE_CLASS = 'c-rating';

export default class FiveStarRating extends LightningElement {
  //initialize public readOnly and value properties
  @api readOnly;
  @api value;

  editedValue;
  isRendered;

  //getter function that returns the correct class depending on if it is readonly
  get starClass() {
    return this.readOnly ? READ_ONLY_CLASS : EDITABLE_CLASS;
  }

  // Render callback to load the script once the component renders.
  renderedCallback() {
    if (this.isRendered) {
      return;
    }
    this.loadScript();
    this.isRendered = true;
  }

  //Method to load the 3rd party script and initialize the rating.
  //call the initializeRating function after scripts are loaded
  //display a toast with error message if there is an error loading script
  loadScript() {
    Promise.all([
      loadStyle(this, fivestar + '/rating.css'),
      loadScript(this, fivestar + '/rating.js')
    ]).then(() => {
      this.initializeRating();
    }).catch(()=>{
      const event = new ShowToastEvent({title:ERROR_TITLE, variant:ERROR_VARIANT});
      this.dispatchEvent(event);
    });
}

  initializeRating() {
    const domEl = this.template.querySelector('ul');
    const maxRating = 5;
    const callback = (rating) => {
      this.editedValue = rating;
      this.ratingChanged(rating);
    };
    this.ratingObj = window.rating(
      domEl,
      this.value,
      maxRating,
      callback.bind(this),
      this.readOnly
    );
  }

  // Method to fire event called ratingchange with the following parameter:
  // {detail: { rating: CURRENT_RATING }}); when the user selects a rating
  ratingChanged(rating) {
    const ratingChangeEvent = new CustomEvent('ratingchange', {
      detail: { rating: rating }
    });
    this.dispatchEvent(ratingChangeEvent);
  }
}