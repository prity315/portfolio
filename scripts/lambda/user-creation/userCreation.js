var aws = require('aws-sdk');
var cognitoIdentityServiceProvider = new aws.CognitoIdentityServiceProvider({ apiVersion: '2016-04-18' });

exports.handler = (event, context, callback) => {
    for (const { body } of event.Records) {
        var user = JSON.parse(body);
        var isUsernameEmail = /(.+)@(.+){2,}\.(.+){2,}/.test(user.username);
        
        var createUserParams = {
            UserPoolId: process.env.user_pool_id,
            Username: user.uuid,
            MessageAction: 'SUPPRESS',
            TemporaryPassword: Buffer.from(user.password, 'base64').toString(),
            UserAttributes: [
                {
                    Name: 'email',
                    Value: isUsernameEmail ? user.username : user.email
                },
                {
                    Name: 'preferred_username',
                    Value: isUsernameEmail ? user.uuid : user.username
                },
                {
                    Name: 'custom:uuid',
                    Value: user.uuid
                },
                {
                    Name: 'custom:edgeUid',
                    Value: user.userId.toString()
                },
                {
                    Name: 'custom:geId',
                    Value: user.geId
                },
                {
                    Name: 'custom:status',
                    Value: '1'
                },
                {
                    Name: 'email_verified',
                    Value: isUsernameEmail ? 'true' : 'false'
                },
                {
                    Name: 'custom:source',
                    Value: user.source
                }
            ]
        };
        
        var setPasswordParams = {
            Password: Buffer.from(user.password, 'base64').toString(),
            UserPoolId: process.env.user_pool_id,
            Username: user.uuid,
            Permanent: true
        };
        
        try {
            cognitoIdentityServiceProvider.adminCreateUser(createUserParams, function (err, data) {
                if (err) {
                    console.log('User creation failed: ' + user.username);
                    context.fail(err);
                }
                else {
                    console.log(JSON.stringify(data));
                    
                    cognitoIdentityServiceProvider.adminSetUserPassword(setPasswordParams, function(err, data) {
                        if (err) {
                            console.log('Admin password not set for user: ' + user.username);
                            console.log(err, err.stack);
                        }
                        else console.log(data);
                    });
                }
            });
        } catch (err) {
            console.log('Failed for user: ' + user.username);
            context.fail(err);
        }
    }
};