import { LightningElement, api } from 'lwc';

// imports
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import BOAT_REVIEW_OBJECT from '@salesforce/schema/BoatReview__c';
import NAME_FIELD from '@salesforce/schema/BoatReview__c.Name';
import COMMENT_FIELD from '@salesforce/schema/BoatReview__c.Comment__c';
import RATING_FIELD from '@salesforce/schema/BoatReview__c.Rating__c';

const SUCCESS_TITLE = 'Review Created!';
const SUCCESS_VARIANT = 'success';

export default class BoatAddReviewForm extends LightningElement {
  // Private
  boatId;
  rating;
  boatReviewObject = BOAT_REVIEW_OBJECT;
  nameField        = NAME_FIELD;
  commentField     = COMMENT_FIELD;
  ratingField      = RATING_FIELD;
  labelSubject = 'Review Subject';
  labelRating  = 'Rating';

  // Public Getter and Setter to allow for logic to run on recordId change
  @api
  get recordId() {
    return this.boatId;
  }
  set recordId(value) {
    this.setAttribute('boatId', value);
    this.boatId = value;
  }

  /**
   * Gets user rating input from stars component
   * @param {CustomEvent} event
   */
  handleRatingChanged(event) {
    this.rating = event.detail.rating;
  }

  /**
   * Custom submission handler to properly set Rating
   * This function must prevent the anchor element from navigating to a URL.
   * @param {CustomEvent} event
   */
  handleSubmit(event) {
    event.preventDefault();
    const fields = event.detail.fields;
    fields.Boat__c = this.boatId;
    fields.Rating__c = this.rating;
    this.template.querySelector('lightning-record-edit-form').submit(fields);
  }

  // Shows a toast message once form is submitted successfully
  // Dispatches event when a review is created
  handleSuccess() {
    // TODO: dispatch the custom event and show the success message
    const successEvent = new ShowToastEvent({
      title: SUCCESS_TITLE,
      variant: SUCCESS_VARIANT,
    })
    this.dispatchEvent(successEvent);

    const notifySuccess = new CustomEvent('createreview');
    this.dispatchEvent(notifySuccess);
    this.handleReset();
  }

  // Clears form data upon submission
  // TODO: it must reset each lightning-input-field
  handleReset() {
    this.template
      .querySelectorAll('lightning-input-field')
      .forEach(element => element.reset());
  }
}