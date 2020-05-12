@IsTest
private class ApexSimpleContinuationPassingData_Test {
  @IsTest
  private static void testApexSimpleContinuationPassingDataForLWC() {
    String mockResponseBody = 'TestBodyResponse';

    Test.startTest();
    Continuation con = (Continuation) ApexSimpleContinuationPassingData.startConinuation();
    Test.stopTest();

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

    Test.setContinuationResponse(
      ApexSimpleContinuationPassingData.continuationLabel,
      response
    );

    List<String> labels = new List<String>{
      ApexSimpleContinuationPassingData.continuationLabel
    };

    String result = (String) ApexSimpleContinuationPassingData.continuationCallback(
      labels,
      ApexSimpleContinuationPassingData.continuationState
    );

    System.assertEquals(
      true,
      result.contains(mockResponseBody),
      'Continuation failed: response body not valid'
    );
    System.assertEquals(true, result.contains('Some data here...'));
  }

  @IsTest
  private static void testContinuationExceptionCaptured() {
    Continuation con = (Continuation) ApexSimpleContinuationPassingData.startConinuation();

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
    Test.setContinuationResponse(
      ApexSimpleContinuationPassingData.continuationLabel,
      response
    );

    List<String> labels = new List<String>{
      ApexSimpleContinuationPassingData.continuationLabel
    };

    Boolean exceptionThrown = false;
    try {
      String result = (String) ApexSimpleContinuationPassingData.continuationCallback(
        labels,
        ApexSimpleContinuationPassingData.continuationState
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
  private static void testHttpRequestExceptionCaptured() {
    Continuation con = (Continuation) ApexSimpleContinuationPassingData.startConinuation();

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
    Test.setContinuationResponse(
      ApexSimpleContinuationPassingData.continuationLabel,
      response
    );

    List<String> labels = new List<String>{
      ApexSimpleContinuationPassingData.continuationLabel
    };

    Boolean exceptionThrown = false;
    try {
      String result = (String) ApexSimpleContinuationPassingData.continuationCallback(
        labels,
        ApexSimpleContinuationPassingData.continuationState
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
