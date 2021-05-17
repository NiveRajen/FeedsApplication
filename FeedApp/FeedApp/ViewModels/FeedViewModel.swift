//
//  FeedViewModel.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import Foundation

//MARK: - FEEDDELEGATE
protocol FeedDelegate {
  
  func throwError(error: String)
  func reloadData()
}

final class FeedViewModel: NSObject {
  
  private var delegate: FeedDelegate?
  var feedList: [Feed]?
  
  init(delegate: FeedDelegate, feedList: [Feed]) {
    self.delegate = delegate
    self.feedList = feedList
  }
  
  ///Feed list from API
  ///
  func getFeeds() {
    ApplicationAPI.shared.getFeeds { result in
      switch result {
      case .success(let feedArray):
        
        self.reloadDataWithGitRepositoryList(feedArray)
        break
      case .failure(let error):
        
        self.errorhandling(error == .noInternet ? Constants.NoInternet : error.localizedDescription)
        break
      }
    }
  }
  
  ///Returns number of rows for the table view data Source
  ///
  /// - Returns number of rows
  func numberOfRows() -> Int {
    return feedList?.count ?? 0
  }
  
  ///Reload data source using feed list Delegate
  ///
  /// - Parameter feeds: array of feed
  func reloadDataWithGitRepositoryList(_ feeds: [Feed]) {
    self.feedList = feeds
    self.delegate?.reloadData()
  }
  
  ///Error Handling
  ///
  /// - Parameter error: error string to throw error
  func errorhandling(_ error: String) {
    
    self.delegate?.throwError(error: error)
  }
  
  ///Show no records
  /// - Returns: A boolen to hide/show no records label
  func showNoRecords() -> Bool {
    return feedList == nil ? true : self.numberOfRows() == 0
  }
}
