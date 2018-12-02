({
    onInit : function(component, helper) {
        var boatId = component.get('v.boat').Id
        console.log(`BoatReviewsHelper-INFO: Preparing to get reviews for '${boatId}'`)

        var action = component.get('c.getAll')
        action.setParams({boatId})
        action.setCallback(this, response => {
            if (response.getState() === 'SUCCESS') {
                console.log('BoatReviewsHelper-INFO: Getting reviews was successfull')
                component.set('v.boatReviews', response.getReturnValue())
            } else {
                console.log('BoatReviewsHelper-INFO: Getting reviews failed')
            }
        })
        $A.enqueueAction(action)
    }
})
