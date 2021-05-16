//
//  CommentsViewController.swift
//  FeedApp
//
//  Created by Nivedha Rajendran on 15/05/21.
//

import UIKit

final class CommentsViewController: UIViewController {
  
  @IBOutlet weak var tblViewComments: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var feed: Feed?
  
  private var dataSource: CustomTableViewDataSource<Comments>? = nil
  typealias completion = (_ success: Bool) -> Void
  
  private var commentsViewModel: CommentsViewModel? {
    
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
  
  private func customInitialization() {
    
    
    self.tblViewComments.estimatedSectionHeaderHeight = 0
    
    startAnimating { success in
      
      if success {
        self.commentsViewModel = CommentsViewModel(delegate: self, commentList: [])
        self.configTableView()
      }
    }
  }
  
  private func configTableView() {
    
    tblViewComments.delegate = self
    tblViewComments.sectionHeaderHeight = UITableView.automaticDimension
    tblViewComments.estimatedSectionHeaderHeight = 64
    tblViewComments.tableFooterView = UIView()
  }
  
  //Reload function to load the data source to table view
  private func renderTableViewdataSource(_ comments: [Comments]) {
    
    dataSource = .displayData(for: comments, with: Constants.commentsTableViewCell)
    
    DispatchQueue.main.async { [weak self] in
      
      guard let self = self else { return }
      self.tblViewComments.dataSource = self.dataSource
      self.tblViewComments.reloadData()
    }
    
    stopAnimating()
  }
}

//MARK: - COMMENTSDELEGATE
extension CommentsViewController: CommentsDelegate {
  func throwError(error: String) {
    
    showAlert(title: Constants.error, msg: error)
  }
  
  func reloadData() {
    
    renderTableViewdataSource(self.commentsViewModel?.commentList ?? [])
  }
}

//MARK: - UITABLEVIEWDELGATE
extension CommentsViewController: UITableViewDelegate {
  internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return header
  }
}

//MARK: - ACTIVITY INDICATOR
extension CommentsViewController {
  private func startAnimating(completionHandler: @escaping(completion)) {
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.activityIndicator.startAnimating()
      completionHandler(true)
    }
  }
  
  private func stopAnimating() {
    
    DispatchQueue.main.async { [weak self] in
      
      guard let self = self else { return }
      self.activityIndicator.stopAnimating()
      self.activityIndicator.isHidden = true
    }
  }
}
