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
