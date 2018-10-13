({
    recordUpdated: function (component, event, helper) {
        var eventParams = event.getParams();
        if (eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            var changedFields = eventParams.changedFields;
            console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            // record is changed so refresh the component (or other component logic)
            helper.showToast("Saved", "The record was updated.")
        } else if (eventParams.changeType === "LOADED") {
            console.log("Record is loaded successfully.");
        } else if (eventParams.changeType === "REMOVED") {
            helper.showToast("Deleted", "The record was deleted.")
        } else if (eventParams.changeType === "ERROR") {
            console.log('Error: ' + component.get("v.error"));
        }
    }
})