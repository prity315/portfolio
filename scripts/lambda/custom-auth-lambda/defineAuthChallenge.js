exports.handler = (event, context, callback) => {
  console.log(event.request.session);
  console.log({ context });
  console.log(event.request);
  if (event.request.session.length == 0) {
    event.response.issueTokens = false;
    event.response.failAuthentication = false;
    event.response.challengeName = "CUSTOM_CHALLENGE";
  } else {
    if (event.request.session) {
      if (event.request.session[0].challengeResult) {
        event.response.issueTokens = true;
        event.response.failAuthentication = false;
      }
    } else {
      event.response.issueTokens = false;
      event.response.failAuthentication = false;
    }
  }
  context.succeed(event);
};
