//
//  APIHelper.swift
//  FeedApp
//
//  Created by Nivedha Rajendran on 16/05/21.
//

import Foundation

struct FeedAPI: APIHandler {
  
  func makeRequest(from data: [String: Any]?) -> Request {
    // url components
    let urlComp = NSURLComponents(string: Constants.baseUrlString + Constants.postsPath)!
    var request = URLRequest(url: urlComp.url!)
    
    request.httpMethod = Constants.getMethod

    let urlrequest = Request(urlRequest: request)
    
    return urlrequest
  }
  
  /// Parse response from data
  ///
  /// - Parameter data: json data
  func parseResponse(data: Data) -> [Feed]? {
    return defaultParseResponse(data: data)
  }
}

struct CommentAPI: APIHandler {
  
  func makeRequest(from id: String) -> Request {
    // url components
    let urlComp = NSURLComponents(string: Constants.baseUrlString + Constants.postsPath + "/\(id)" + Constants.commentsPath)!
    var request = URLRequest(url: urlComp.url!)
    
    request.httpMethod = Constants.getMethod
    
    let urlrequest = Request(urlRequest: request)
    
    return urlrequest
  }
  
  /// Parse response from data
  ///
  /// - Parameter data: json data
  func parseResponse(data: Data) -> [Comments]? {
    return defaultParseResponse(data: data)
  }
}
