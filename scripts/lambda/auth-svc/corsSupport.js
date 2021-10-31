const utils = require("/opt/utils");

exports.handler = async (event, context, callback) => {
console.log("Event : ", JSON.stringify(event));
try {
    const origin = event.headers.origin;
    let headers = utils.getHeaders(origin);

    const response = {
        statusCode: 200,
        headers,
        body: JSON.stringify("Success from OPTION call!"),
    };
    callback(null, response);
} catch (error) {
    console.log("Error while getting headers! ", error);
    callback(null, "Error while getting headers!");
    }
};
