exports.handler = (event, context, callback) => {
  console.log({ context });
  event.response.answerCorrect = true;
  context.succeed(event);
};
