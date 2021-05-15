//
//  FeedsModel.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import Foundation

struct Feed: Decodable {
  var userId: Int
  var postId: Int
  var title: String?
  var body: String?
  
  private enum CodingKeys: String, CodingKey {
    case userId
    case postId = "id"
    case title
    case body
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    userId = try values.decode(Int.self, forKey: .userId)
    postId = try values.decode(Int.self, forKey: .postId)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    body = try values.decodeIfPresent(String.self, forKey: .body)
  }
}

struct Comments: Decodable {
  var postId: Int
  var userId: Int
  var name: String?
  var email: String?
  var body: String?
  
  private enum CodingKeys: String, CodingKey {
    case postId
    case userId = "id"
    case name
    case email
    case body
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    userId = try values.decode(Int.self, forKey: .userId)
    postId = try values.decode(Int.self, forKey: .postId)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    email = try values.decodeIfPresent(String.self, forKey: .email)
    body = try values.decodeIfPresent(String.self, forKey: .body)
  }
}
