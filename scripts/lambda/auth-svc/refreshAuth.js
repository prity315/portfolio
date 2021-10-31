const utils = require("/opt/utils");
const constants = require("/opt/constants.js");
var URL = require('url').URL;

exports.handler = async (event, context, callback) => {
    console.log("Event: "+JSON.stringify((event)));
    
    let environment = process.env.environment;
    const domain = constants.domains.learnship[environment];
    let geId;
    let geAuthResponse;
    let tokens;
    let redirect;
    let headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Credentials': true,
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent',
        'Access-Control-Allow-Methods': 'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'
    };
    
    try {
        redirect = verifyRedirectUrl(event);
        headers.Location = redirect;

        tokens = await utils.getTokenByRefreshToken(process.env.auth_client_id, process.env.auth_client_secret, event.queryStringParameters.token);
        const idToken = tokens.id_token;
        
        geId = JSON.parse(Buffer.from(idToken.split('.')[1], 'base64'))["custom:geId"];
        geAuthResponse = await utils.getGEAuthToken(geId);

        var geAuthCookie = (environment === "production" ? "" : environment)+"geauth="+geAuthResponse.geauth+"; path=/; domain="+domain+";";
        var idTokenCookie = process.env.aws_env+"IdToken="+idToken+"; path=/; domain="+domain+";";
        
        var response = {
            statusCode: 302,
            headers,
            multiValueHeaders: {
                'Set-Cookie': [geAuthCookie, idTokenCookie]
            },
        };
        callback(null, response);
    } catch (err) {
        console.log('Error for user: ', geId);
        console.log(err);
        var errResponse = {
            statusCode: 302,
            headers: {
                'Location': redirect
            }
        };
        callback(null, errResponse);
    }
};

function verifyRedirectUrl(event) {
    let redirectUrlParams;
    let redirectUrl;
    
    if (event.queryStringParameters.redirectUrl || event.queryStringParameters.redirect) {
        redirectUrlParams = new URL(event.queryStringParameters.redirectUrl || event.queryStringParameters.redirect);
        if (redirectUrlParams != null && (redirectUrlParams.host.match(/globalenglish/) || redirectUrlParams.host.match(/learnship/)))
            redirectUrl = redirectUrlParams.href;
        else 
            redirectUrl = constants.learnerPortalUrls[process.env.environment];
    } else {
        redirectUrl = constants.learnshipLoginUrls[process.env.environment];
    }
    return redirectUrl;
}
