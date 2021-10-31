exports.handler = (event, context, callback) => {
  if (event.request.challengeName == "CUSTOM_CHALLENGE") {
    console.log({ context });
    event.response.publicChallengeParameters = {};
    event.response.publicChallengeParameters.answer = "12345";
    event.response.privateChallengeParameters = {};
    event.response.privateChallengeParameters.answer = "12345";
    event.response.challengeMetadata = "PASSWORDLESS_AUTH_FLOW";
  }
  context.succeed(event);
};


