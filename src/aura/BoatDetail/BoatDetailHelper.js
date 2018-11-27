({
    detectIfDetailsAvailable : function(component) {
        var isEnabled = Boolean($A.get("e.force:navigateToSObject"))
        if (isEnabled) {
            console.log('BoatDetailHelper-INFO: Navigation is enabled')
        } else {
            console.log('BoatDetailHelper-INFO: Navigation is NOT enabled')
        }
        component.set('v.detailsAvailable', isEnabled)
    }
})