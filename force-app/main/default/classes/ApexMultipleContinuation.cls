public with sharing class ApexMultipleContinuation {
  // IMPORTANT: Variables used for testing, containing the reerences to the different Continuation requests
  @TestVisible
  private static String continuationLabel1;
  @TestVisible
  private static String continuationLabel2;

  private final static Integer CONTINUATION_TIMEOUT_IN_SECONDS = 40;
  private final static String HTTP_REQUEST_ENDPOINT = 'callout:TestEndpoint';

  /**
   *  @description    Create the Continuation instance and start the defined callout
   *  @returns        The Continuation object
   */
  @AuraEnabled(continuation=true cacheable=true)
  public static Object startConinuation() {
    // Create the callout Request
    HttpRequest req1 = new HttpRequest();
    req1.setMethod('GET');
    req1.setEndpoint(HTTP_REQUEST_ENDPOINT + '/2');

    HttpRequest req2 = new HttpRequest();
    req2.setMethod('GET');
    req2.setEndpoint(HTTP_REQUEST_ENDPOINT + '/5');

    // Create the continuation
    Continuation con = new Continuation(CONTINUATION_TIMEOUT_IN_SECONDS);
    con.ContinuationMethod = 'continuationCallback';

    continuationLabel1 = con.addHttpRequest(req1);
    continuationLabel2 = con.addHttpRequest(req2);

    return con;
  }

  /**
     *  @description    Call the Continuation callback, setting up the Continuation context
     *  @param          Object state : private attribute of the Continuation object containing a reference to the Http Request
                                        This variable can be used to pass data from the startContinuation() function to the callback function
     *  @return         The response of the Continuation, that is sent to the client-side
     */
  @AuraEnabled(cacheable=true)
  public static Object continuationCallback(List<String> labels, Object state) {
    HttpResponse response1 = Continuation.getResponse(labels[0]);
    Integer statusCode1 = response1.getStatusCode();
    if (statusCode1 >= 2000) {
      // Continuation error
      throw new AuraHandledException(
        'Continuation Error: ' +
        statusCode1 +
        ' - ' +
        response1.getBody()
      );
    } else if (statusCode1 != 200) {
      // Http Request error
      throw new AuraHandledException(
        'HTTP Request Error: ' +
        statusCode1 +
        ' - ' +
        response1.getBody()
      );
    }

    HttpResponse response2 = Continuation.getResponse(labels[1]);
    Integer statusCode2 = response2.getStatusCode();
    if (statusCode2 >= 2000) {
      // Continuation error
      throw new AuraHandledException(
        'Continuation Error: ' +
        statusCode2 +
        ' - ' +
        response2.getBody()
      );
    } else if (statusCode2 != 200) {
      // Http Request error
      throw new AuraHandledException(
        'HTTP Request Error: ' +
        statusCode2 +
        ' - ' +
        response2.getBody()
      );
    }

    return new List<String>{ response1.getBody(), response2.getBody() };
  }
}
