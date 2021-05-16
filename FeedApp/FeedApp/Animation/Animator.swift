//
//  Animator.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 16/05/21.
//

import UIKit

// Animator class to init and check for cell to animate for indexpath
final class Animator {
  
  private var hasAnimatedAllCells = false
  private let animation: Animation
  
  // Initilizing animation with completionhandler
  init(animation: @escaping Animation) {
    self.animation = animation
  }
  
  ///Animate using cell, at indexpath, tableview
  func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
    
    guard !hasAnimatedAllCells else {
      return
    }
    
    animation(cell, indexPath, tableView)
    
    hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
  }
}
