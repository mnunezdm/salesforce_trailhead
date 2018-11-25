({
    doInit: function(component, event, helper) {
        helper.onSearch(component, '')
    },
    doSearch: function(component, event, helper) {
        console.log('Do search called...')
        var formData = event.getParam('arguments')
        helper.onSearch(component, formData.boatTypeId)
    }
})