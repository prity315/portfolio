const utils = require("/opt/utils");
const constants = require("/opt/constants");
var URL = require('url').URL;
var origin;

exports.handler = async (event) => {
    console.log("Event: "+JSON.stringify((event)));
    
    const environment = process.env.environment;
    if (event.httpMethod === 'GET' && event.headers.origin == null) {
        origin = constants.geUrls[environment];
    } else {
        origin = event.headers.origin;
    }
    const awsEnv = process.env.aws_env;
    let headers = utils.getHeaders(origin);
    let domain = constants.domains.learnship[environment];
    var responseBody = {
        'msg': 'Success'
    };
    responseBody.url = verifyRedirectUrl(event);
    let geId;
    let geAuthResponse;
    let response;
    let idToken;
    let tmsLoginSession;

  try {
    if (event.requestContext.authorizer) {
        geId = event.requestContext.authorizer.claims["custom:geId"];
        geAuthResponse = await utils.getGEAuthToken(geId);
        idToken = awsEnv+"IdToken="+event.headers.Authorization+"; path=/; domain="+domain+";";
    }

    if (event.headers.Cookie && JSON.stringify(event.headers.Cookie).includes(awsEnv+'IdToken') && !JSON.stringify(event.headers.Cookie).includes("learnship_8493")) {
        console.log("Got the idToken set in cookie, The user is already logged in.");
        response = {
            statusCode: 200,
            headers,
            body: JSON.stringify(responseBody),
            isBase64Encoded: false
            };
    } else if (geAuthResponse != null) {
        if (geAuthResponse.status == 0) {
            responseBody.isActive = "0";
            response = {
                statusCode: 200,
                headers,
                body: JSON.stringify(responseBody),
                isBase64Encoded: false
            };
        } else {
            let envPrefix;
            if (environment === "production") {
                envPrefix = "";
            } else if (awsEnv == "dynamic") {
                envPrefix = "test";
            } else {
                envPrefix = environment;
            }
            var geauth = envPrefix+"geauth="+geAuthResponse.geauth+"; path=/; domain="+domain+";";
            // var geauth = (environment === "production" ? "" : environment)+"geauth="+geAuthResponse.geauth+"; path=/; domain="+domain+";";
            response = {
                statusCode: 200,
                headers,
                multiValueHeaders: {
                    'Set-Cookie': [geauth, idToken]
                },
                body: JSON.stringify(responseBody),
                isBase64Encoded: false
            };
        }
    } else if (geAuthResponse == null && event.httpMethod === 'POST') {
        let tmsLoginSessionResponse = await utils.getTMSLoginByIdToken(event.headers.Authorization);
        if (tmsLoginSessionResponse.statusCode === 200) {
            tmsLoginSession = tmsLoginSessionResponse.headers['set-cookie'];
            console.log("tmsLoginSession: ", tmsLoginSession);
            tmsLoginSession = tmsLoginSession[0].replace("learnship_8493=", "learnship_8493v2=");

            response = {
                statusCode: 200,
                headers,
                multiValueHeaders: {
                    'Set-Cookie': [idToken, tmsLoginSession]
                },
                body: JSON.stringify(responseBody),
                isBase64Encoded: false
            };
        } else if (tmsLoginSessionResponse.statusCode === 403) {
            let email;
            if (event.requestContext.authorizer) {
                email = event.requestContext.authorizer.claims["email"];
            }
            responseBody.msg = "forbidden";
            responseBody.resetPasswordUrl = `${constants.lsUrls[environment]}/login/login?expired=true&username=${email}`;
            response = {
                statusCode: 403,
                headers,
                body: JSON.stringify(responseBody),
                isBase64Encoded: false
            };
        }
    } else if(event.queryStringParameters != null && event.queryStringParameters.token && event.httpMethod === 'GET') {
        idToken = awsEnv+"IdToken="+event.queryStringParameters.token+"; path=/; domain="+domain+";";
        headers.Location = responseBody.url;
        response = {
            statusCode: 302,
            headers,
            multiValueHeaders: {
                'Set-Cookie': [idToken]
            },
        };
    } else {
        response = {
            statusCode: 401,
            headers,
            isBase64Encoded: false
            };
    }
    console.log("Response: ", response);
    return response;
  } catch(error) {
        console.log('Error for user: ', geId);
        console.log(error);
        var errorResponse = {
            statusCode: error.statusCode,
            body: JSON.stringify({
                'statusCode': error.statusCode,
                'code': error.msg}),
        };
        return errorResponse;
    }
};

function verifyRedirectUrl(event) {
    const environment = process.env.environment;
    let redirectUrlParams;
    let redirectUrl;
    
    if (event.queryStringParameters != null && (event.queryStringParameters.redirectUrl || event.queryStringParameters.redirect)) {
        redirectUrlParams = new URL(event.queryStringParameters.redirectUrl || event.queryStringParameters.redirect);
        if (redirectUrlParams != null && (redirectUrlParams.host.match(/globalenglish/) || redirectUrlParams.host.match(/learnship/)))
            redirectUrl = redirectUrlParams;
        else 
            redirectUrl = constants.learnerPortalUrls[environment];
    } else {
        redirectUrl = constants.learnerPortalUrls[environment];
    }
    console.log("Redirect Url is: ", redirectUrl);
    return redirectUrl;
}