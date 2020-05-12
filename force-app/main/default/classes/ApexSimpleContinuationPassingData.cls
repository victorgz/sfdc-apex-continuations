public with sharing class ApexSimpleContinuationPassingData {
  @TestVisible
  private static String continuationLabel; // IMPORTANT: Variable used for testing, containing a reference to the Continuation Request
  @TestVisible
  private static String continuationState; // IMPORTANT: Variable used for testing, containing the value of the Continuation.state attribute

  private final static Integer CONTINUATION_TIMEOUT_IN_SECONDS = 40;
  private final static String HTTP_REQUEST_ENDPOINT = 'callout:TestEndpoint';

  /**
   *  @description    Create the Continuation instance and start the defined callout
   *  @returns        The Continuation object
   */
  @AuraEnabled(continuation=true cacheable=true)
  public static Object startConinuation() {
    // Create the callout Request
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(HTTP_REQUEST_ENDPOINT);

    // Create the continuation
    Continuation con = new Continuation(CONTINUATION_TIMEOUT_IN_SECONDS);
    con.ContinuationMethod = 'continuationCallback';

    continuationLabel = con.addHttpRequest(req); // Store the reference to the HttRequest and make it accessible for a test-context

    continuationState = 'Some data here...'; // Store data to be sent to the callback function
    con.state = continuationState;

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
    HttpResponse response = Continuation.getResponse(labels[0]);

    Integer statusCode = response.getStatusCode();
    if (statusCode == 200) {
      return (String) state + ' - ' + response.getBody();
    } else if (statusCode >= 2000) {
      // Continuation error
      throw new AuraHandledException(
        'Continuation Error: ' +
        statusCode +
        ' - ' +
        response.getBody()
      );
    } else {
      // Http Request error
      throw new AuraHandledException(
        'HTTP Request Error: ' +
        statusCode +
        ' - ' +
        response.getBody()
      );
    }
  }
}
