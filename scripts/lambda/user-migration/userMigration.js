var request = require("request-promise").defaults({ jar: true });
const appConstants = require('./constants');
let hostname;

exports.handler = async (event, context, callback) => {
  const envConfig = process.env.environment;
  hostname = appConstants.urls[envConfig];

  if (event.triggerSource == 'UserMigration_Authentication') {
    var user;
    var isUsernameEmail;
    var uuid = [];
    var lsUser = await authLearnshipUser(event.userName, event.request.password);

    if (lsUser.statusCode === 403) {
      //  TODO: We can make this better. Since we can't send extra attribute in Error object,
      //  appended the resetPasswordUrl in message attribute so that the same can be used in FE.
      let errorMsg = new Error("PasswordExpiredException:"+`${appConstants.lsUrl[envConfig]}/login/login?expired=true&username=${event.userName}`);
      callback(errorMsg, event);
    }

    if (lsUser && lsUser.isValid) {
      var lsUuid = await getUuidFromLS();
      var isLSUsernameEmail = /(.+)@(.+){2,}\.(.+){2,}/.test(event.userName);

      event.response.userAttributes = {
        email: event.userName, //LS only user always have email as their username.
        email_verified: isLSUsernameEmail ? true : false,
        username:
          lsUuid && lsUuid.isValid
            ? lsUuid.data.uuid
            : function() {
              throw new Error('UUID not found');
            },
        preferred_username: isLSUsernameEmail
          ? lsUuid.data.uuid
          : event.userName,
        'custom:source': 'Learnship',
        'custom:uuid': lsUuid && lsUuid.isValid
             ? lsUuid.data.uuid
             : function() {
              throw new Error('UUID not found');
            }
      };
      console.log("User is found in Learnship system, Cognito will create the user in user pool: ", event.response.userAttributes);
    } else {
      user = await authUser(event.userName, event.request.password);
      if (user && user.isValid) {
        if (user.details.lms == '1') {
          var error = new Error('DirectLoginNotAllowedException');
          callback(error, event);
        } else if (user.details.status == '0') {
          error = new Error('DisableInactiveUserException');
          callback(error, event);
        }
        uuid = await getUuid(user.details.edgeUid);
        isUsernameEmail = /(.+)@(.+){2,}\.(.+){2,}/.test(user.details.username);
        event.response.userAttributes = {
          email: isUsernameEmail ? user.details.username : user.details.email,
          email_verified: isUsernameEmail ? true : false,
          'custom:edgeUid': user.details.edgeUid,
          'custom:status': user.details.status,
          'custom:geId': user.details.geId + "    ",
          'custom:source': 'GlobalEnglish',
          'custom:uuid': uuid && uuid.isValid
             ? uuid.details[0].GeUUID
             : function() {
              throw new Error('UUID not found');
            },
          username:
            uuid && uuid.isValid
              ? uuid.details[0].GeUUID
              : function() {
                  throw new Error('UUID not found');
                },
          preferred_username: isUsernameEmail
            ? uuid.details[0].GeUUID
            : event.userName
        };
        console.log('User found in GE, Cognito will create the user');
      } else {
          console.log('Invalid Credentials');
          throw new Error('Invalid Credentials');
      }
    }
    event.response.finalUserStatus = 'CONFIRMED',
    event.response.messageAction = 'SUPPRESS';
    context.succeed(event);
  } else {
    console.log('Bad triggerSource');
    throw new Error('Bad triggerSource ' + event.triggerSource);
  }
};

/**
 * Authenticates the user and get the user details from GE system
 * @param {*} userName
 * @param {*} password
 */
function authUser(userName, password) {
  const isUsernameEmail = /(.+)@(.+){2,}\.(.+){2,}/.test(userName);
  const uri = isUsernameEmail
    ? `https://${userName}:${encodeURIComponent(password)}@${
      hostname
      }/people`
    : `https://${encodeURIComponent(userName)}:${encodeURIComponent(
        password
      )}@${hostname}/people`;
  var options = {
    uri: uri,
    json: true,
    resolveWithFullResponse: true
  };
  var user = {};
  return request(options)
    .then(function(response) {
      if (response && response.statusCode === 200) {
        user.details = response.body;
        user.isValid = true;
        return Promise.resolve(user);
      } else {
        user.isValid = false;
        return Promise.resolve(user);
      }
    })
    .catch(function(error) {
      user.isValid = false;
      console.log(error);
      return Promise.reject(user);
    });
}

/**
 * Get the UUID details for the user from geuuid_mapping table from GE system
 * @param {*} userId
 */
function getUuid(userId) {
  var options = {
    uri: `https://${hostname}/users/${userId}/uuidmapping`,
    json: true,
    method: 'PUT',
    qs: {
      app_key: `${appConstants.appKey.test}`,
      cognito_migrated: '1'
    },
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    resolveWithFullResponse: true
  };
  var uuid = {};
  return request(options)
    .then(function(response) {
      if (response && response.statusCode === 200) {
        uuid.details = response.body;
        uuid.isValid = true;
        return Promise.resolve(uuid);
      } else {
        uuid.isValid = false;
        return Promise.resolve(uuid);
      }
    })
    .catch(function(error) {
      uuid.isValid = false;
      console.log(error);
      return Promise.reject(uuid);
    });
}

/**
 * Authenticates the Learnship user with username & password from TMS system and saves the session id
 * @param {*} userName
 * @param {*} password
 */
function authLearnshipUser(userName, password) {

  var lsHostname = appConstants.lsUrl[process.env.environment];
  var options = {
    uri: `${lsHostname}/login/session`,
    json: true,
    method: 'POST',
    body: {
      "username": userName,
      "password": password
    },
    resolveWithFullResponse: true
  };
  var user = {};

  return request(options)
    .then(function(response) {
      if (response && response.statusCode === 200) {
        user.isValid = true;
        return Promise.resolve(user);
      } else {
        user.isValid = false;
        return Promise.resolve(user);
      }
    })
    .catch(function(error) {
      user.isValid = false;
      user.statusCode = error.statusCode;
      console.log(error);
      return Promise.resolve(user);
    });
}

/**
 * Authenticates the user with the session id saved from above API, and get the UUID for the user from TMS system
 */
function getUuidFromLS() {
  var host = appConstants.lsUrl[process.env.environment];
  var options = {
    uri: `${host}/login/session/user`,
    json: true,
    resolveWithFullResponse: true
  };
  var lsUserResponse = {};

  return request(options)
    .then(function(response) {
      if (response && response.statusCode === 200) {
        lsUserResponse.data = response.body;
        lsUserResponse.isValid = true;
        return Promise.resolve(lsUserResponse);
      } else {
        lsUserResponse.isValid = false;
        return Promise.resolve(lsUserResponse);
      }
    })
    .catch(function(error) {
      lsUserResponse.isValid = false;
      console.log(error);
      return Promise.reject(lsUserResponse);
    });
}
