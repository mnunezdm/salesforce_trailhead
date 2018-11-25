({
    createItem : function(component, item) {
        var event = component.getEvent('addItem')
        event.setParams({
            "item": item
        })
        event.fire()
        console.log('EVENT FIRED')
        component.set("v.newItem",{'sobjectType':'Camping_Item__c',
                'Name': '',
                'Quantity__c': 0,
                'Price__c': 0,
                'Packed__c': false});
    }
})