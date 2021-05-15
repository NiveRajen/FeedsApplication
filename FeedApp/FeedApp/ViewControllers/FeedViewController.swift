//
//  ViewController.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import UIKit

class FeedViewController: UIViewController {
  
  @IBOutlet weak var tblViewFeed: UITableView!
  var dataSource: CustomTableViewDataSource<Feed>? = nil
  
  var feedViewModel: FeedViewModel? {
    
    didSet {
      feedViewModel?.getFeeds()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    customInitialization()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  func customInitialization() {
    
    self.feedViewModel = FeedViewModel(delegate: self, feedList: [])
    tblViewFeed.register(UINib(nibName: Constants.feedCellView, bundle: nil), forCellReuseIdentifier: Constants.feedTableViewCell)
  }

  //Reload function to load the data source to table view
  func renderTableViewdataSource(_ feed: [Feed]) {
    
    dataSource = .displayData(for: feed, with: Constants.feedTableViewCell)
    DispatchQueue.main.async { [weak self] in
      
      guard let self = self else { return }
      self.tblViewFeed.dataSource = self.dataSource
      self.tblViewFeed.reloadData()
    }
  }
}

//MARK: FEED DELEGATE
extension FeedViewController: FeedDelegate {
  func throwError(error: String) {
    
    showAlert(title: Constants.error, msg: error)
  }
  
  func reloadData() {
    
    renderTableViewdataSource(self.feedViewModel?.feedList ?? [])
  }
}

//MARK: UITABLEVIEWDELEGATE
extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let feed = self.feedViewModel?.feedList?[indexPath.row] {
      navigateToComments(for: feed)
    }
  }
}

//MARK: NAVIGATION
extension FeedViewController {
  private func navigateToComments(for feed: Feed?) {
    if let feed = feed {
      guard let commentVC = self.storyboard?.instantiateViewController(identifier: Constants.commentsVCIdentifier) as? CommentsViewController else { return }
      commentVC.feed = feed
      
      self.navigationController?.pushViewController(commentVC, animated: true)
    }
  }
}
