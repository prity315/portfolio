exports.handler = (event, context, callback) => {
  const response = event.Records[0].cf.response;
  const headers = response.headers;

  const headerHSTS = "Strict-Transport-Security";
  const headerCSP = "Content-Security-Policy";
  const headerXFO = "X-Frame-Options";
  const headerXSSP = "X-XSS-Protection";
  const headerXCTO = "X-Content-Type-Options";
  const headerCacheControl = "Cache-control";
  const headerPragma = "Pragma";
  const headerReferrerPolicy = "Referrer-Policy";

  headers[headerXFO.toLowerCase()] = [{ key: headerXFO, value: "SAMEORIGIN" }];
  headers[headerHSTS.toLowerCase()] = [
    {
      key: headerHSTS,
      value: "max-age=31536000; includeSubdomains; preload",
    },
  ];
  headers[headerCSP.toLowerCase()] = [
    {
      key: headerCSP,
      value:
        "default-src 'self' gap: gap-iab:; script-src 'self' https://*.globalenglish.com 'unsafe-inline' 'unsafe-eval'; connect-src 'self' 'unsafe-inline' https://*.bugsnag.com/ https://*.amazonaws.com https://*.globalenglish.com https://*.learnship.today https://*.learnship.tech https://*.learnship.com; img-src 'self' data: https://*.globalenglish.com; font-src 'self' data:; style-src 'self' 'unsafe-inline'; manifest-src https://*.globalenglish.com https://*.learnship.today https://*.learnship.tech https://*.learnship.com; report-uri https://8f38d7397afbc4ccc8e536badebd2a03.m.pipedream.net/;",
    },
  ];
  headers[headerXSSP.toLowerCase()] = [
    { key: headerXSSP, value: "1; mode=block" },
  ];
  headers[headerCacheControl.toLowerCase()] = [
    { key: headerCacheControl, value: "no-store" },
  ];
  headers[headerPragma.toLowerCase()] = [
    { key: headerPragma, value: "no-cache" },
  ];
  headers[headerXCTO.toLowerCase()] = [{ key: headerXCTO, value: "nosniff" }];
  headers[headerReferrerPolicy.toLowerCase()] = [
    { key: headerReferrerPolicy, value: "same-origin" },
  ];

  return callback(null, response);
};
