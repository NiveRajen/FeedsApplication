//
//  MockAPI.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 16/05/21.
//

import Foundation

final class MockAPI {
  static let shared = MockAPI()
  private init() {}
  
  func mockFeed(completion: @escaping (_ result: Result<[Feed], RequestError>) -> Void) {
    
    // Add MockURLProtocol to protocol classes
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession(configuration: configuration)
    // Mock response
    let sampleResponse =
      """
        [
        {
        "userId": 1,
        "id": 1,
        "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "body": "quia et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto"
        },
        {
        "userId": 1,
        "id": 2,
        "title": "qui est esse",
        "body": "est rerum tempore vitae sequi sint nihil reprehenderit dolor beatae ea dolores neque fugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis qui aperiam non debitis possimus qui neque nisi nulla"
        },
        {
        "userId": 1,
        "id": 3,
        "title": "ea molestias quasi exercitationem repellat qui ipsa sit aut",
        "body": "et iusto sed quo iure voluptatem occaecati omnis eligendi aut ad voluptatem doloribus vel accusantium quis pariatur molestiae porro eius odio et labore et velit aut"
        },
        ]
        """
    let mockJSONData = sampleResponse.data(using: .utf8)!
    // request handler
    MockURLProtocol.requestHandler = { request in
      return (HTTPURLResponse(), mockJSONData)
    }
    // Request object
    let request = FeedAPI()
    let apiTaskLoader = APILoader(apiRequest: request, urlSession: urlSession)
    apiTaskLoader.loadAPIRequest(requestData: nil) { (result) in
      completion(result)
    }
  }
}
