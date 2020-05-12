@IsTest
private class ApexContinuation_Test {
  @IsTest
  private static void testApexContinuationForLWC() {
    String mockResponseBody = 'TestBodyResponse';

    Test.startTest();
    Continuation con = (Continuation) ApexContinuation.startConinuation();

    // Verify that the continuation has the correct number of requests
    Map<String, HttpRequest> requests = con.getRequests();
    System.assertEquals(
      1,
      requests.size(),
      'The number of requests associated to the Continuation is not correct'
    );

    // Create a mock response
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    response.setBody(mockResponseBody);

    Test.setContinuationResponse(ApexContinuation.continuationState, response);

    //Object result = Test.invokeContinuationMethod(new ApexContinuation(), con);
    String result = (String) ApexContinuation.continuationCallback(
      ApexContinuation.continuationState
    );
    Test.stopTest();

    System.assertEquals(
      mockResponseBody,
      result,
      'Continuation failed: response body not valid'
    );
  }

  @IsTest
  private static void testContinuationExceptionCaptured() {
    Test.startTest();
    Continuation con = (Continuation) ApexContinuation.startConinuation();

    // Verify that the continuation has the correct number of requests
    Map<String, HttpRequest> requests = con.getRequests();
    System.assertEquals(
      1,
      requests.size(),
      'The number of requests associated to the Continuation is not correct'
    );

    // Create a mock response
    HttpResponse response = new HttpResponse();
    response.setStatusCode(2000);
    Test.setContinuationResponse(ApexContinuation.continuationState, response);

    Boolean exceptionThrown = false;
    try {
      //Object result = Test.invokeContinuationMethod(new ApexContinuation(), con);
      Object result = ApexContinuation.continuationCallback(
        ApexContinuation.continuationState
      );
    } catch (AuraHandledException e) {
      exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(
      true,
      exceptionThrown,
      'Failed to catch Continuation Exception'
    );
  }

  @IsTest
  private static void testHttpRequestExceptionCaptured() {
    Test.startTest();
    Continuation con = (Continuation) ApexContinuation.startConinuation();

    // Verify that the continuation has the correct number of requests
    Map<String, HttpRequest> requests = con.getRequests();
    System.assertEquals(
      1,
      requests.size(),
      'The number of requests associated to the Continuation is not correct'
    );

    // Create a mock response
    HttpResponse response = new HttpResponse();
    response.setStatusCode(400);
    Test.setContinuationResponse(ApexContinuation.continuationState, response);

    Boolean exceptionThrown = false;
    try {
      //Object result = Test.invokeContinuationMethod(new ApexContinuation(), con);
      Object result = ApexContinuation.continuationCallback(
        ApexContinuation.continuationState
      );
    } catch (AuraHandledException e) {
      exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(
      true,
      exceptionThrown,
      'Failed to catch Http Request Exception'
    );
  }
}
