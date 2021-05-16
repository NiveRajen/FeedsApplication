//
//  APIHandler.swift
//  FeedApp
//
//  Created by Nivedha Rajendran on 16/05/21.
//

import Foundation

// MARK: - Errors
struct NetworkError: Error {
  let message: String
}

struct UnknownParseError: Error { }

//MARK: - Request & Response Handler
protocol RequestHandler {
  associatedtype RequestDataType
  
  func makeRequest(from data: RequestDataType) -> Request
}

protocol ResponseHandler {
  
  associatedtype ResponseDataType
  
  func parseResponse(data: Data) -> ResponseDataType?
}

typealias APIHandler = RequestHandler & ResponseHandler

//MARK: - Request

class Request {
  private var request: URLRequest
  
  init(urlRequest: URLRequest) {
    self.request = urlRequest
  }
  
  var urlRequest: URLRequest {
    return request
  }
}

extension ResponseHandler {
  /// generic response data parser
  func defaultParseResponse<T: Decodable>(data: Data) -> [T]? {
    
    return T.decodedData(data)
  }
}
