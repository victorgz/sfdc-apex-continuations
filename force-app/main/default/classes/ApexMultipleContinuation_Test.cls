@IsTest
private class ApexMultipleContinuation_Test {
  @IsTest
  private static void testApexMultipleContinuationForLWC() {
    String mockResponseBody1 = 'TestBodyResponse1';
    String mockResponseBody2 = 'TestBodyResponse2';

    Continuation con = (Continuation) ApexMultipleContinuation.startConinuation();

    // Verify that the continuation has the correct number of requests
    Map<String, HttpRequest> requests = con.getRequests();
    System.assertEquals(
      2,
      requests.size(),
      'The number of requests associated to the Continuation is not correct'
    );

    // Create a mock response
    HttpResponse response1 = new HttpResponse();
    response1.setStatusCode(200);
    response1.setBody(mockResponseBody1);

    HttpResponse response2 = new HttpResponse();
    response2.setStatusCode(200);
    response2.setBody(mockResponseBody2);

    Test.setContinuationResponse(
      ApexMultipleContinuation.continuationLabel1,
      response1
    );
    Test.setContinuationResponse(
      ApexMultipleContinuation.continuationLabel2,
      response2
    );

    List<String> labels = new List<String>{
      ApexMultipleContinuation.continuationLabel1,
      ApexMultipleContinuation.continuationLabel2
    };

    List<String> result = (List<String>) ApexMultipleContinuation.continuationCallback(
      labels,
      null
    );

    System.assertEquals(
      mockResponseBody1,
      result.get(0),
      'Continuation failed: response body not valid for request 1'
    );
    System.assertEquals(
      mockResponseBody2,
      result.get(1),
      'Continuation failed: response body not valid for request 2'
    );
  }

  @IsTest
  private static void testContinuationExceptionCapturedInFirstRequest() {
    Continuation con = (Continuation) ApexMultipleContinuation.startConinuation();

    // Verify that the continuation has the correct number of requests
    Map<String, HttpRequest> requests = con.getRequests();
    System.assertEquals(
      2,
      requests.size(),
      'The number of requests associated to the Continuation is not correct'
    );

    // Create a mock response
    HttpResponse response1 = new HttpResponse();
    response1.setStatusCode(2000);

    HttpResponse response2 = new HttpResponse();
    response2.setStatusCode(200);

    Test.setContinuationResponse(
      ApexMultipleContinuation.continuationLabel1,
      response1
    );
    Test.setContinuationResponse(
      ApexMultipleContinuation.continuationLabel2,
      response2
    );
    List<String> labels = new List<String>{
      ApexMultipleContinuation.continuationLabel1,
      ApexMultipleContinuation.continuationLabel2
    };

    Boolean exceptionThrown = false;
    try {
      List<String> result = (List<String>) ApexMultipleContinuation.continuationCallback(
        labels,
        null
      );
    } catch (AuraHandledException e) {
      exceptionThrown = true;
    }

    System.assertEquals(
      true,
      exceptionThrown,
      'Failed to catch Continuation Exception'
    );
  }

  @IsTest
  private static void testHttpRequestExceptionCapturedInFirstRequest() {
    Continuation con = (Continuation) ApexMultipleContinuation.startConinuation();

    // Verify that the continuation has the correct number of requests
    Map<String, HttpRequest> requests = con.getRequests();
    System.assertEquals(
      2,
      requests.size(),
      'The number of requests associated to the Continuation is not correct'
    );

    // Create a mock response
    HttpResponse response1 = new HttpResponse();
    response1.setStatusCode(400);

    HttpResponse response2 = new HttpResponse();
    response2.setStatusCode(200);

    Test.setContinuationResponse(
      ApexMultipleContinuation.continuationLabel1,
      response1
    );
    Test.setContinuationResponse(
      ApexMultipleContinuation.continuationLabel2,
      response2
    );
    List<String> labels = new List<String>{
      ApexMultipleContinuation.continuationLabel1,
      ApexMultipleContinuation.continuationLabel2
    };

    Boolean exceptionThrown = false;
    try {
      List<String> result = (List<String>) ApexMultipleContinuation.continuationCallback(
        labels,
        null
      );
    } catch (AuraHandledException e) {
      exceptionThrown = true;
    }

    System.assertEquals(
      true,
      exceptionThrown,
      'Failed to catch Http Request Exception'
    );
  }
}
