//
//  ViewController.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import UIKit
import Network

final class FeedViewController: UIViewController {
  
  @IBOutlet weak var tblViewFeed: UITableView!
  @IBOutlet weak var activityLoader: UIActivityIndicatorView!
  @IBOutlet weak var lblNoRecords: UILabel!
  
  var dataSource: CustomTableViewDataSource<Feed>? = nil
  typealias completion = (_ success: Bool) -> Void
  
  private var feedViewModel: FeedViewModel? {

    didSet {
      feedViewModel?.getFeeds()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    customInitialization()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    NetworkCheck.sharedInstance.removeObserver(observer: self)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private func customInitialization() {
    
    NetworkCheck.sharedInstance.addObserver(observer: self)
    startAnimating { success in
      
      if success {
        
        self.feedViewModel = FeedViewModel(delegate: self, feedList: [])
        let nibName = UINib(nibName: Constants.feedCellView, bundle: nil)
        self.tblViewFeed.register(nibName, forCellReuseIdentifier: Constants.feedTableViewCell)
      }
    }
  }

  //Reload function to load the data source to table view
  private func renderTableViewdataSource(_ feed: [Feed]) {
    
    DispatchQueue.main.async { [weak self] in
      
      guard let self = self else { return }
      
      self.dataSource = .displayData(for: feed, with: Constants.feedTableViewCell)
      self.tblViewFeed.dataSource = self.dataSource
      self.tblViewFeed.reloadData()
    }
    
    stopAnimating()
  }
  
  //Hiding the table view if there is no data
  private func hideShowTableView() {
    
    DispatchQueue.main.async {[weak self] in
      guard let self = self else { return }
      
      self.tblViewFeed.isHidden = (self.feedViewModel?.showNoRecords() ?? false)
      self.lblNoRecords.isHidden = !(self.feedViewModel?.showNoRecords() ?? true)
      self.activityLoader.stopAnimating()
    }
  }
}

//MARK: FEED DELEGATE
extension FeedViewController: FeedDelegate {
  func throwError(error: String) {
    
    hideShowTableView()
    showAlert(title: Constants.error, msg: error)
  }
  
  func reloadData() {
    
    hideShowTableView()
    renderTableViewdataSource(self.feedViewModel?.feedList ?? [])
  }
}

//MARK: UITABLEVIEWDELEGATE
extension FeedViewController: UITableViewDelegate {
  internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let feed = self.feedViewModel?.feedList?[indexPath.row] {
      navigateToComments(for: feed)
    }
  }
  
  internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    let animation = BounceAnimation.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 1.0, delayFactor: 0.05)
    let animator = Animator(animation: animation)
    animator.animate(cell: cell, at: indexPath, in: tblViewFeed)
  }
}

//MARK: NAVIGATION
extension FeedViewController {
  private func navigateToComments(for feed: Feed?) {
    if let feed = feed {
      guard let commentVC = self.storyboard?.instantiateViewController(identifier: Constants.commentsVCIdentifier) as? CommentsViewController else { return }
      commentVC.feed = feed
      
      DispatchQueue.main.async {[weak self] in
        
        guard let self = self else { return }
        self.navigationController?.pushViewController(commentVC, animated: true)
      }
    }
  }
}

//MARK: - ACTIVITY INDICATOR
extension FeedViewController {
  private func startAnimating(completionHandler: @escaping(completion)) {
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.activityLoader.startAnimating()
      completionHandler(true)
    }
  }
  
  private func stopAnimating() {
    
    DispatchQueue.main.async { [weak self] in
      
      guard let self = self else { return }
      self.activityLoader.stopAnimating()
      self.activityLoader.isHidden = true
    }
  }
}

//MARK: - NETWORKCHECKOBSERVER
extension FeedViewController: NetworkCheckObserver {
  func statusDidChange(status: NWPath.Status) {
    if status == .satisfied {
      
      startAnimating { success in
        if success {
          
          self.feedViewModel?.getFeeds()
        }
      }
    } else {
        hideShowTableView()
    }
  }
}
