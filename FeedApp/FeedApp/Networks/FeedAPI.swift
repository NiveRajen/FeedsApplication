//
//  FeedAPI.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import Foundation

class FeedAPI {
  static let shared = FeedAPI()
  private init() {}
  
  ///Getting feeds
  ///
  /// - Parameter completionHandler: returns Return type and request error
  func getFeeds(completionHandler: @escaping(_ result: Result<[Feed], RequestError>) -> Void) {
    
    let urlComp = NSURLComponents(string: Constants.baseUrlString + Constants.postsPath)!
    var request = URLRequest(url: urlComp.url!)
    
    request.httpMethod = Constants.getMethod
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, res, err) in
      
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
        
        guard let decodedData: [Feed] = Feed.decodedData(data) else {
          completionHandler(.failure(.dataDecodingError))
          return
        }
        
        completionHandler(.success(decodedData))
      } else {
        completionHandler(.failure(.noInternet))
      }
    }
    task.resume()
  }
  
  ///Getting feeds
  ///
  /// - Parameter completionHandler: returns Return type and request error
  func getComments(for id: String, completionHandler: @escaping(_ result: Result<[Comments], RequestError>) -> Void) {
    
    let urlComp = NSURLComponents(string: Constants.baseUrlString + Constants.postsPath + "/\(id)" + Constants.commentsPath)!
    var request = URLRequest(url: urlComp.url!)
    
    request.httpMethod = Constants.getMethod
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, res, err) in
      
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
        
        guard let decodedData: [Comments] = Comments.decodedData(data) else {
          completionHandler(.failure(.dataDecodingError))
          return
        }
        
        completionHandler(.success(decodedData))
      } else {
        completionHandler(.failure(.noInternet))
      }
    }
    task.resume()
  }
}
