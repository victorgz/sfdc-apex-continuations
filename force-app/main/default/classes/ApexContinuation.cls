/*************************************************************************************************************
 * @description   Apex Continuation class for a single callout
 * @author			  Victor Garcia Zarco <victor.gzarco@gmail.com>
 * @date  			  12 / 05 / 2020
 **************************************************************************************************************/
public with sharing class ApexContinuation {
  @TestVisible
  private static String continuationState; // IMPORTANT: Variable used for testing, containing the value of the Continuation.state
  private final static Integer CONTINUATION_TIMEOUT_IN_SECONDS = 40;
  private final static String HTTP_REQUEST_ENDPOINT = 'callout:TestEndpoint';

  /*********************************************************************************************************
   * @description   Create the Continuation instance and start the defined callout
   * @author			  Victor Garcia Zarco <victor.gzarco@gmail.com>
   * @date  			  12 / 05 / 2020
   * @return			  The Continuation object
   **********************************************************************************************************/
  @AuraEnabled(continuation=true cacheable=true)
  public static Object startConinuation() {
    // Create the callout Request
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(HTTP_REQUEST_ENDPOINT);

    // Create the continuation
    Continuation con = new Continuation(CONTINUATION_TIMEOUT_IN_SECONDS);
    con.ContinuationMethod = 'continuationCallback';

    continuationState = con.addHttpRequest(req); // Store the HttRequest and make it accessible for a test-context
    con.state = continuationState;

    return con;
  }

  /*********************************************************************************************************
   * @description   The implementation of the Continuation callback
   * @author			  Victor Garcia Zarco <victor.gzarco@gmail.com>
   * @date  			  12 / 05 / 2020
   * @param			    state : a private attribute of the Continuation object containing a reference to the Http Request. This variable is
   *                        used to pass data from the startContinuation() function to the callback function
   * @return			  The response of the Continuation callout
   **********************************************************************************************************/
  @AuraEnabled(cacheable=true)
  public static Object continuationCallback(Object state) {
    HttpResponse response = Continuation.getResponse((String) state);

    Integer statusCode = response.getStatusCode();
    if (statusCode == 200) {
      return response.getBody();
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
