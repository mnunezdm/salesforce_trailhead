({
    onFormSubmit: function(component, event, helper) {
        var formData = event.getParam('formData')
        console.log('BoatSearchController-INFO: Event controlled for', formData.boatTypeId)
        var searchComponent = component.find("search");
        searchComponent.search(formData.boatTypeId)
    }
})