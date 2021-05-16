//
//  APILoader.swift
//  FeedApp
//
//  Created by Nivedha Rajendran on 16/05/21.
//

import Foundation

class APILoader<T: APIHandler> {
  
  let apiRequest: T
  
  let urlSession: URLSession
  
  init(apiRequest: T, urlSession: URLSession = .shared) {
    self.apiRequest = apiRequest
    self.urlSession = urlSession
  }
  
  func loadAPIRequest(requestData: T.RequestDataType,
                                    completionHandler: @escaping (_ result: Result<T.ResponseDataType, RequestError>) -> Void) {
    
    // prepare url request
    let urlRequest = apiRequest.makeRequest(from: requestData).urlRequest
    // do session task
    urlSession.dataTask(with: urlRequest) { (data, res, err) in
      
      if NetworkCheck.sharedInstance().currentStatus == .satisfied {
        
        guard err == nil else {
          completionHandler(.failure(.clientError))
          return
        }
        
        guard let response = res as? HTTPURLResponse, 200...299 ~= response.statusCode else {
          completionHandler(.failure(.serverError))
          return
        }
        
        guard let data = data else {
          completionHandler(.failure(.noData))
          return
        }
        
        if let decoded = self.apiRequest.parseResponse(data: data) {
          completionHandler(.success(decoded))
        } else {
          completionHandler(.failure(.dataDecodingError))
        }
        
      } else {
        completionHandler(.failure(.noInternet))
      }
    }.resume()
  }
}
