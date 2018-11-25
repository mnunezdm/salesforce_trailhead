({
    doInit: function(component, event, helper) {
        console.log('Initializing component')
        var action = component.get("c.getExpenses")
        action.setCallback(this, function(response) {
            var state = response.getState()
            if (state === "SUCCESS") {
                var responseBody = response.getReturnValue()
                console.log(response)
                console.log(`Returned a total of ${responseBody.length}`)
                component.set("v.expenses", responseBody)
            }
            else {
                console.log("Failed with state: " + state)
            }
        })
        $A.enqueueAction(action)
    },
    clickCreate: function(component, event, helper) {
        var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid()
            return validSoFar && inputCmp.get('v.validity').valid
        }, true)
        // If we pass error checking, do some real work
        if(validExpense){
            // Create the new expense
            var newExpense = component.get("v.newExpense")
            console.log("Create expense: " + JSON.stringify(newExpense))
            helper.createExpense(component, newExpense)
        }
    },
    handleUpdateExpense: function(component, event, helper) {
        var updatedExp = event.getParam("expense");
        helper.updateExpense(component, updatedExp);
    }
})