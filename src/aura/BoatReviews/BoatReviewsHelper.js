({
    onInit : function(component, helper) {
        var boatId = component.get('v.boat').Id
        console.log(`BoatReviewsHelper-INFO: Preparing to get reviews for '${boatId}'`)

        var action = component.get('c.getAll')
        action.setParams({boatId})
        action.setCallback(this, response => {
            if (response.getState() === 'SUCCESS') {
                var reviews = response.getReturnValue()
                console.log(`BoatReviewsHelper-INFO: Retrieved a total of ${reviews.length} reviews`)
                component.set('v.boatReviews', response.getReturnValue())
            } else {
                console.log('BoatReviewsHelper-INFO: Getting reviews failed')
            }
        })
        $A.enqueueAction(action)
    }
})
