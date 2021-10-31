const utils = require("/opt/utils");
const appConstants = require("/opt/constants");

exports.handler = async (event) => {

    const origin = event.headers.origin;
    let headers = utils.getHeaders(origin);
    let domain = appConstants.domains.learnship[process.env.environment];
    var excludeCookies = ["ulang", "cookiepolicy"];
    var resetCookies = [];

    if (event.headers.Cookie) {
        var cookies = event.headers.Cookie.split(";");
        cookies.forEach(cookie => {
            var parts = cookie.split("=");
            var cookieName = parts[0].trim();
            if (!excludeCookies.includes(cookieName)) {
                cookieName = cookieName+"=''; expires="+new Date(0)+"; path=/; domain="+domain+";";
                resetCookies.push(cookieName);
            }
        });
    }
    const response = {
        statusCode: 200,
        headers,
        multiValueHeaders: {
            'Set-Cookie': resetCookies
        },
        body: JSON.stringify("Success"),
    };
    console.log("Response is: ", JSON.stringify(response));
    return response;
    };
