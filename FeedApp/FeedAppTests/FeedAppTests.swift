//
//  FeedAppTests.swift
//  FeedAppTests
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import XCTest
@testable import FeedApp

class FeedAppTests: XCTestCase {

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
  
  func test_FeedsAPI() {
    let expectation = XCTestExpectation(description: "Json data")
    let urlComp = NSURLComponents(string: Constants.baseUrlString + Constants.postsPath)!
    var request = URLRequest(url: urlComp.url!)
    
    XCTAssertNotNil(request.url)
    request.httpMethod = Constants.getMethod
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, res, err) in
      do {
        
        XCTAssertNotNil(res)
        XCTAssertTrue(res is HTTPURLResponse)
        XCTAssertNotNil(data)
        
        //Check for valid data and not nil values
        if let httpUrlResponse = res as? HTTPURLResponse {
          XCTAssertEqual(httpUrlResponse.statusCode, 200)
        }
        
        let jsonDecoder = JSONDecoder()
        let feedArray = try jsonDecoder.decode([Feed].self, from: data!)
        XCTAssertNotNil(feedArray)
        
        expectation.fulfill()
      } catch {
        
        // The request is finished, so our expectation
        expectation.fulfill()
      }
    }
    task.resume()
    
    // We ask the unit test to wait our expectation to finish.
    self.wait(for: [expectation], timeout: 25)
  }

}
