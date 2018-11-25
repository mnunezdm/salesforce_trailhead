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
    handleCreateExpense: function(component, event, helper) {
        var newExpense = event.getParam("expense");
        helper.createExpense(component, newExpense)
    },
    handleUpdateExpense: function(component, event, helper) {
        var updatedExp = event.getParam("expense");
        helper.updateExpense(component, updatedExp);
    }
})