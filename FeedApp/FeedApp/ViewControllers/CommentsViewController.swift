//
//  CommentsViewController.swift
//  FeedApp
//
//  Created by Nivedha Rajendran on 15/05/21.
//

import UIKit

class CommentsViewController: UIViewController {
  
  @IBOutlet weak var tblViewComments: UITableView!
  var feed: Feed?
  
  var dataSource: CustomTableViewDataSource<Comments>? = nil
  
  var commentsViewModel: CommentsViewModel? {
    
    didSet {
      commentsViewModel?.getComments(for: String(feed?.postId ?? 0))
    }
  }
  
  
  init(with feed: Feed) {
    self.feed = feed
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private lazy var header: FeedTableViewCell = {
    guard let headerView = Bundle.main.loadNibNamed(Constants.feedCellView,
                                                    owner: self,
                                                    options: nil)?.first as? FeedTableViewCell
    else { return FeedTableViewCell() }
    
    headerView.lblTitle.text = feed?.title
    headerView.lblPostBody.text = feed?.body
    
    return headerView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customInitialization()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  func customInitialization() {
    
    self.commentsViewModel = CommentsViewModel(delegate: self, commentList: [])
  }
  
  //Reload function to load the data source to table view
  func renderTableViewdataSource(_ comments: [Comments]) {
    
    dataSource = .displayData(for: comments, with: Constants.commentsTableViewCell)
    
    DispatchQueue.main.async { [weak self] in
      
      guard let self = self else { return }
      self.tblViewComments.dataSource = self.dataSource
      self.tblViewComments.reloadData()
    }
  }
}

extension CommentsViewController: CommentsDelegate {
  func throwError(error: String) {
    
    showAlert(title: Constants.error, msg: error)
  }
  
  func reloadData() {
    
    renderTableViewdataSource(self.commentsViewModel?.commentList ?? [])
  }
}

//MARK: TABLEVIEW
extension CommentsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return header.bounds.height
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return header
  }
}
