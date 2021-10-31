exports.handler = (event, context, callback) => {
    console.log("event", event.request);
    var userAttributes = event.request.userAttributes;
    var geId = null;
    var customGeId = userAttributes['custom:geId'];
    if (!customGeId) {
        callback(null, event);
    } else {
        geId = customGeId.trim();
        event.response = {
            "claimsOverrideDetails": {
                "claimsToAddOrOverride": {
                    "custom:geId": geId
                }
            }
        }
    }
    callback(null, event);
};