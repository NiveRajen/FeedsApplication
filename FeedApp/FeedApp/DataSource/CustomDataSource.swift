//
//  CustomDataSource.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import UIKit

/// Reusable custom table view data source
class CustomTableViewDataSource<Model>: NSObject, UITableViewDataSource {
  
  typealias CellConfigurator = (Model, UITableViewCell) -> Void //Cell configurator using Model and UITableViewCell Class
  var models: [Model]
  private let resuseIdentifier: String
  private let cellConfigurator: CellConfigurator
  var rowArray: [Int] = []
  
  //Initialization for data Source with model, reuseidentifier and cell configurator
  init(with models: [Model], _ reuseIdentifier: String, and cellConfigurator: @escaping CellConfigurator) {
    
    self.models = models
    self.resuseIdentifier = reuseIdentifier
    self.cellConfigurator = cellConfigurator
  }
  
  //Data Source
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let model = models[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath)
    cellConfigurator(model,cell)
    
    return cell
  }
}

//MARK: - MODEL CLASS VERIFCATION
extension CustomTableViewDataSource where Model == Feed {
  
  ///GitRepository cell configuration
  ///
  /// - Parameter itemList: feeds
  /// - Parameter cellIdentifier: cell identifier
  /// - Returns: Customtableview datasource
  
  static func displayData(for itemList: [Feed], with cellIdentifier: String) -> CustomTableViewDataSource {
    
    return CustomTableViewDataSource(with: itemList,
                                     cellIdentifier) { (feed, cell) in
      let feedCell = cell as? FeedTableViewCell
      feedCell?.feed = feed
    }
  }
  
}

//MARK: - MODEL CLASS VERIFCATION COMMENTS
extension CustomTableViewDataSource where Model == Comments {
  
  ///GitRepository cell configuration
  ///
  /// - Parameter itemList: comments
  /// - Parameter cellIdentifier: cell identifier
  /// - Returns: Customtableview datasource
  
  static func displayData(for itemList: [Comments], with cellIdentifier: String) -> CustomTableViewDataSource {
    
    return CustomTableViewDataSource(with: itemList,
                                     cellIdentifier) { (comment, cell) in
      let feedCell = cell as? CommentsTableViewCell
      feedCell?.comment = comment
    }
  }
  
}
