const appConstants = require('/opt/constants');
const request = require('request-promise');
let geForgotUrl, lsForgotUrl;
exports.handler = async (event) => {
    const environment = process.env.environment;
    geForgotUrl = appConstants.geUrls[environment];
    lsForgotUrl = appConstants.lsUrls[environment];
    const headers = {
        "Access-Control-Allow-Origin": "*"
    };
    const successResponse = {
        headers,
        statusCode: 200,
        body: JSON.stringify({ message: 'PASSWORDSENT' })
    };
    const invalidResponse = {
        statusCode: 200,
        headers,
        body: JSON.stringify({ message: "INVALIDEMAIL" })
    };
    const notFoundResponse = {
        headers,
        statusCode: 200,
        body: JSON.stringify({ message: "MAILNOTFOUND" })
    };
    const multipleAccountResponse = {
        headers,
        statusCode: 200,
        body: JSON.stringify({ message: "CONTACTADMIN_FORGOTEMAIL" })
    };
    const lsNotFoundResponse = {
        headers,
        statusCode: 200,
        body: JSON.stringify({ message: "SHORTLY_PASSWORDSENT"})
    }
    if (event.queryStringParameters && event.queryStringParameters.email) {
        var geEmailResponse, lsEmailResponse;
        const userEmail = event.queryStringParameters.email;
        const isValidEmail = /(.+)@(.+){2,}\.(.+){2,}/.test(userEmail);
        if (!isValidEmail) {
            return invalidResponse;
        }
        geEmailResponse = await geForgotPassword(userEmail);
        console.log({ geEmailResponse });
        if (geEmailResponse.isSent) {
            return successResponse;
        } else if (geEmailResponse.isMultipleAccount) {
            return multipleAccountResponse;
        } else {
            lsEmailResponse = await lsForgotPassword(userEmail);
            console.log({ lsEmailResponse });
            if (lsEmailResponse.isSent) {
                return successResponse;
            } else {
                return lsNotFoundResponse;
            }    
        }
        
    }
};
function geForgotPassword(email) {
    console.log(geForgotUrl);
    var options = {
        uri: `https://${geForgotUrl}/password?email=${email}`,
        method: 'GET',
        json: true,
        resolveWithFullResponse: true
    };
    var sentEmailResponse = {};
    return request(options)
        .then(function (response) {
            if (response &&
                response.body &&
                response.body.message == "PASSWORDSENT" ||
                response.body.message == "REACHTEMPPASSWORDSENT") {
                sentEmailResponse.isSent = true;
                sentEmailResponse.isMultipleAccount = false;
                return Promise.resolve(sentEmailResponse);
            } else if (response &&
                response.body &&
                response.body.message == "CONTACTADMIN_FORGOTEMAIL") {
                sentEmailResponse.isSent = false;
                sentEmailResponse.isMultipleAccount = true;
                return Promise.resolve(sentEmailResponse);
            } else {
                sentEmailResponse.isSent = false;
                sentEmailResponse.isMultipleAccount = false;
                return Promise.resolve(sentEmailResponse);
            }
        })
        .catch(function (_error) {
            sentEmailResponse.isSent = false;
            return Promise.resolve(sentEmailResponse);
        });
}
function lsForgotPassword(email) {
    console.log(lsForgotUrl);
    var options = {
        uri: `${lsForgotUrl}/login/passwordRequest`,
        method: 'POST',
        json: true,
        body: { username: email },
        resolveWithFullResponse: true
    };
    var sentEmailResponse = {};
    return request(options)
        .then(function (response) {
            console.log({ response });
            if (response &&
                response.statusCode === 200) {
                sentEmailResponse.isSent = true;
                return Promise.resolve(sentEmailResponse);
            } else {
                sentEmailResponse.isSent = false;
                return Promise.resolve(sentEmailResponse);
            }
        })
        .catch(function (response) {
            console.log({ response });
            sentEmailResponse.isSent = false;
            return Promise.resolve(sentEmailResponse);
        });
}