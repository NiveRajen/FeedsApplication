//
//  FeedAPI.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import Foundation

class ApplicationAPI {
  static let shared = ApplicationAPI()
  private init() {}
  
  ///Getting feeds
  ///
  /// - Parameter completionHandler: returns Return type and request error
  func getFeeds(completionHandler: @escaping(_ result: Result<[Feed], RequestError>) -> Void) {
    
    let api = FeedAPI()
    let apiTaskLoader = APILoader(apiRequest: api)
    
    apiTaskLoader.loadAPIRequest(requestData: nil) { result in
      completionHandler(result)
    }
  }
  
  ///Getting feeds
  ///
  /// - Parameter completionHandler: returns Return type and request error
  func getComments(for id: String, completionHandler: @escaping(_ result: Result<[Comments], RequestError>) -> Void) {
    
    let api = CommentAPI()
    let apiTaskLoader = APILoader(apiRequest: api)
    
    apiTaskLoader.loadAPIRequest(requestData: id) { result in
      completionHandler(result)
    }
  }
}
