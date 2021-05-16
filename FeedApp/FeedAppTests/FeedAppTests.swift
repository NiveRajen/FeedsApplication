//
//  FeedAppTests.swift
//  FeedAppTests
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import XCTest
@testable import FeedApp

class FeedAppTests: XCTestCase {
  let request = FeedAPI()
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testMakeRequest() {
    
    let urlRequest = request.makeRequest(from: nil).urlRequest
    
    XCTAssertNotNil(urlRequest)
    XCTAssertEqual(urlRequest.httpMethod, Constants.getMethod)
    XCTAssertNil(urlRequest.httpBody)
    
    XCTAssertEqual(urlRequest.url?.absoluteString, Constants.baseUrlString + Constants.postsPath)
  }
  
  func test200Response() {
    let sampleResponse =
      """
        [{
        "userId": 1,
        "id": 1,
        "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "body": "quia et suscipitsuscipit recusandae consequuntur expedita et cumreprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto"
        }]
        """
    let jsonData = sampleResponse.data(using: .utf8)!
    
    XCTAssertNotNil(try JSONDecoder().decode([Feed].self, from: jsonData))
  }
  
  func testUnknownError() {
    let sampleResponse =
      """
        {
            "dummy text"
        }
        """
    let jsonData = sampleResponse.data(using: .utf8)!
    
    XCTAssertNil(request.parseResponse(data: jsonData))
  }
}

class MockFeedAPI: XCTestCase {
  let mockAPI = MockAPI.shared
  
  func test_MockTest() {
    let expectation = XCTestExpectation(description: "Json data")
    
    mockAPI.mockFeed { result in
      
      switch result {
      
      case .success(let feedArray):
        XCTAssertNotNil(feedArray)
        
        // The request is finished, so our expectation
        expectation.fulfill()
        break
        
      case .failure(let error):
        XCTAssertNil(error)
        
        // The request is finished, so our expectation
        expectation.fulfill()
        break
      }
    }
    
    self.wait(for: [expectation], timeout: 25)
  }
}
