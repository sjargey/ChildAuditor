({
	doInit : function(component) {
        
        var action = component.get("c.getChildsMap");
        
        action.setParams({ rId : component.get("v.recordId") });
        console.log("rId" + component.get("v.recordId"));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var resultsMap = response.getReturnValue();
            var fieldsInfo = [];
            for(var key in resultsMap){
                    fieldsInfo.push({value:resultsMap[key], key:key});
                }
             component.set("v.childList",fieldsInfo);  	
                
             console.log(fieldsInfo);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });        
        $A.enqueueAction(action);
    }
})