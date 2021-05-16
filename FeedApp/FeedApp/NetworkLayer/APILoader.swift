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
  
  func loadAPIRequest<U: Decodable>(requestData: T.RequestDataType,
                      completionHandler: @escaping (_ result: Result<[U], RequestError>) -> Void) {
    
    // prepare url request
    let urlRequest = apiRequest.makeRequest(from: requestData).urlRequest
    // do session task
    urlSession.dataTask(with: urlRequest) { (data, res, err) in
      
      if Reachability.isConnectedToNetwork() {
        
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
        
        guard let decodedData: [U] = U.decodedData(data) else {
          completionHandler(.failure(.dataDecodingError))
          return
        }
        
        completionHandler(.success(decodedData))
      } else {
        completionHandler(.failure(.noInternet))
      }
    }.resume()
  }
}
