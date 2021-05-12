//
//  Enum.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import Foundation

///Error Enum
enum RequestError: Error {
  case clientError
  case serverError
  case noData
  case dataDecodingError
  case noInternet
}
