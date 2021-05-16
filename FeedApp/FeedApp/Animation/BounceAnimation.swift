//
//  BounceAnimation.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 16/05/21.
//

import UIKit

typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

enum BounceAnimation {
  /// Bounce animation with rowheight
  ///
  /// - Parameter rowHeight: float value with row height
  /// - Parameter duration: duration of the animation
  /// - Parameter delayFactor: double in delay factor
  /// - Parameter Animation: returns animations
  static func makeMoveUpWithBounce(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
    
    return { cell, indexPath, tableView in
      cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
      
      UIView.animate(
        withDuration: duration,
        delay: delayFactor,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 0.1,
        options: [.curveEaseInOut],
        animations: {
          cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
  }
}
