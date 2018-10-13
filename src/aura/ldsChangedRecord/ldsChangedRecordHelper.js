({
    showToast : function(title, message) {
        var resultsToast = $A.get("e.force:showToast");
        if (resultsToast) {
            resultsToast.setParams({
                "title": title,
                "message": message
            });
            resultsToast.fire();
        } else {
            console.log('Not in Salesforce APP so no toast available, showing alert instead')
            alert(`${title}: ${message}`)
        }
    }
})
