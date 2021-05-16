//
//  CommetnsViewModel.swift
//  FeedApp
//
//  Created by Nivedha Rajendran on 15/05/21.
//

import Foundation

//MARK: - COMMENTSDELEGATE
protocol CommentsDelegate {
  
  func throwError(error: String)
  func reloadData()
}

final class CommentsViewModel: NSObject {
  
  private var delegate: CommentsDelegate?
  var commentList: [Comments]?
  
  init(delegate: CommentsDelegate, commentList: [Comments]) {
    self.delegate = delegate
    self.commentList = commentList
  }
  
  ///Feed list from API
  ///
  func getComments(for id: String) {
    ApplicationAPI.shared.getComments(for: id) { result in
      switch result {
      case .success(let commentArray):
        
        self.reloadDataWithGitRepositoryList(commentArray)
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
    return commentList?.count ?? 0
  }
  
  ///Reload data source using feed list Delegate
  ///
  /// - Returns: array of feed
  func reloadDataWithGitRepositoryList(_ comments: [Comments]) {
    self.commentList = comments
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
    return commentList == nil ? true : self.numberOfRows() == 0
  }
}
