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
  var feedVC: FeedViewController?
  
  override func setUpWithError() throws {
    
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    feedVC = storyBoard.instantiateViewController(withIdentifier: Constants.feedViewController) as? FeedViewController
    _ = feedVC?.view
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
  
  //MARK: TEST CASES FOR TABLE VIEW
  func test_CheckForTableView() {
    
    XCTAssertNotNil(feedVC?.tblViewFeed)
  }
  
  // Check for Table View delegate and Data source
  func test_CheckForDataSourceAndDelegate() {
    
    XCTAssertNotNil(feedVC?.tblViewFeed.delegate is FeedViewController)
    XCTAssertNotNil(feedVC?.tblViewFeed.dataSource is CustomTableViewDataSource<Feed>)
  }
  
  //Check for numberOfRows
  func test_CheckForRowCount() {
    
    feedVC?.dataSource = .displayData(for: [], with: Constants.feedTableViewCell)
    feedVC?.tblViewFeed.dataSource = feedVC?.dataSource
    XCTAssertTrue(feedVC?.tblViewFeed.numberOfRows(inSection: 0) ?? 0 == 0)
  }
  
  let jsonDataString = Data("""
        [{
        "userId": 1,
        "id": 1,
        "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "body": "quia et suscipitsuscipit recusandae consequuntur expedita et cumreprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto"
        }]
        """.utf8)
  
  func test_CheckForNotNilArray() {
    let feeds = try? JSONDecoder().decode([Feed].self, from: jsonDataString)
    
    feedVC?.dataSource = .displayData(for: feeds ?? [], with: Constants.feedTableViewCell)
    feedVC?.tblViewFeed.dataSource = feedVC?.dataSource
    feedVC?.tblViewFeed.reloadData()
    
    XCTAssertTrue(feedVC?.tblViewFeed.numberOfRows(inSection: 0) ?? 0 > 0)
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
