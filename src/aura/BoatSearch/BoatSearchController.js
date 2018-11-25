({
    onFormSubmit: function(component, event, helper) {
        var formData = event.getParam('formData')
        console.log('event controlled', formData.boatTypeId)
    }
})