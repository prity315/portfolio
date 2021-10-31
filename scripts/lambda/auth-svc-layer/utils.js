const request = require('request-promise');
const appConstants = require('./constants');
const extractDomain = require('extract-domain');

let hostname;
let domain;
let envConfig = process.env.environment;
const ALLOWED_ORIGINS = [
	'learnship.today',
    'learnship.tech',
    'learnship.com',
    'globalenglish.com'
];

hostname = appConstants.urls[envConfig];
domain = appConstants.domains.learnship[envConfig];
cognitoBaseUrl = appConstants.cognitoBaseUrls[envConfig];

function getGEAuthToken(geId) {
    var options = {
        uri: `https://${hostname}/people/${geId}`,
        method: 'GET',
        json: true,
        qs: {
            app_key: `${appConstants.appKey.test}`,
            fields: 'urls,geauth'
        },
        resolveWithFullResponse: true
    };
    
    var apiResponse = {};
    return request(options)
    .then(function(response){
        if(response && response.statusCode === 200) {
            apiResponse = response.body;
            return Promise.resolve(apiResponse);
        }
    })
    .catch(function(error) {
        console.log("Error while fetching API response...");
        return Promise.reject(error);
    });
}

const getDomain = () => domain;

function getHeaders(origin) {
    let originDomain = extractDomain(origin);
    if (ALLOWED_ORIGINS.includes(originDomain)) {
        return {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Credentials': true,
            'Access-Control-Allow-Origin': origin,
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent',
            'Access-Control-Allow-Methods': 'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'
        };
    }
}

function getTokenByRefreshToken(clientId, clientSecret, refreshToken) {
    const url = cognitoBaseUrl + '/oauth2/token';
    console.log('url ', url);
    var options = {
        method: 'POST',
        uri: url,
        json: true,
        form: {
            "grant_type": "refresh_token",
            "client_id": clientId,
            "client_secret": clientSecret,
            "refresh_token": refreshToken
        },
        headers: {
            "Accept": "application/json",
            "content-type": "application/x-www-form-urlencoded",
        },
        resolveWithFullResponse: true
    }
    var apiResponse = {};
    return request(options)
    .then(function(response){
        console.log('res ', response);
        if(response && response.statusCode === 200) {
            apiResponse = response.body;
            return apiResponse;
        }
    })
    .catch(function(error) {
        console.log('err ', error);
        console.log("Error while fetching getTokenByRefreshToken API response...");
        return error;
    });
}

function getTMSLoginByIdToken(cognitoIdToken){
    var hostname = appConstants.lsUrls[envConfig];
    var options = {
        uri: `${hostname}/login/session`,
        method: 'POST',
        headers: {
            "Content-Type": "text/plain",
            'id-token': cognitoIdToken
        },
        withCredentials: true,
        resolveWithFullResponse: true
    };

    return request(options)
    .then(function(response){
        console.log('TMS login API response is: ', JSON.stringify(response));
        if(response && response.statusCode === 200) {
            return response;
        }
    })
    .catch(function(error) {
        console.log("Error while fetching TMS login/session API response...", error);
        return error;
    });
}

module.exports = {
    getGEAuthToken,
    getDomain,
    getHeaders,
    getTokenByRefreshToken,
    getTMSLoginByIdToken
};
