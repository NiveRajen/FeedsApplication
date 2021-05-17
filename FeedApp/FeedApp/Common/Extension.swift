//
//  Extension.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import Foundation
import UIKit

//MARK: - DECODABLE
extension Decodable {
  
  static func decodedData<T: Decodable>(_ data: Data) -> [T]? {
    
    let jsonDecoder = JSONDecoder()
    return try? jsonDecoder.decode([T].self, from: data)
  }
}

//Draw Curve and Line path for rounded coner for view for each and every edge with different radius
//MARK: - UIBEZIERPATH
extension UIBezierPath {
  convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
    
    self.init()
    
    let path = CGMutablePath()
    
    let topLeft = rect.origin
    let topRight = CGPoint(x: rect.maxX, y: rect.minY)
    let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
    let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
    
    if topLeftRadius != .zero{
      path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
    } else {
      path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
    }
    
    if topRightRadius != .zero{
      path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
      path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
    } else {
      path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
    }
    
    if bottomRightRadius != .zero{
      path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
      path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
    } else {
      path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
    }
    
    if bottomLeftRadius != .zero{
      path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
      path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
    } else {
      path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
    }
    
    if topLeftRadius != .zero{
      path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
      path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
    } else {
      path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
    }
    
    path.closeSubpath()
    cgPath = path
  }
}

//MARK: - UIView
extension UIView {
  /// Creatng diagonal gradient layer with start and end color for cells
  ///
  /// - Parameter startColor: starting color of gradient layer
  /// - Parameter endColor: ending color of gradient layer
  func addGradientLayer(with startColor: UIColor, and endColor: UIColor) {
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.bounds
    
    let gradientOffset = self.bounds.height / self.bounds.width / 2
    
    gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5 - gradientOffset)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5 + gradientOffset)
    
    self.layer.insertSublayer(gradientLayer, at: 0)
  }
}

//MARK: UICOLOR
extension UIColor {
  /// Converting hexstring to color with alpha
  ///
  /// - Parameter hexString: String
  /// - Parameter alpha: float value ranges between 0.0 to 1.0
  convenience init(hexString: String, alpha: CGFloat = 1.0) {
    
    let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let scanner = Scanner(string: hexString)
    
    if (hexString.hasPrefix("#")) {
      scanner.scanLocation = 1
    }
    
    var color: UInt32 = 0
    scanner.scanHexInt32(&color)
    
    //mark
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    
    self.init(red:red, green:green, blue:blue, alpha:alpha)
  }
  
  //Stored Properties with custom color
  static let DarkBlue = UIColor(hexString: "#1E3AFF")
  static let CoralBlue = UIColor(hexString: "#54C0DB")
  static let Purple = UIColor(hexString: "#7133D9")
  static let BubbleGum = UIColor(hexString: "#FB3770")
}

//MARK: UIVIEW CONTROLLER
extension UIViewController {
  ///Present alert for UI View Controller
  ///
  /// - Parameter title: title as string
  /// - Parameter alert: alert message as string
  func showAlert(title: String?, msg: String?)  {
    
    let okAction = UIAlertAction(title: Constants.ok, style: .default, handler: nil)
    
    guard let alertMessage = msg, let alertTitle = title?.capitalized else { return }
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      alert.addAction(okAction)
      self.present(alert, animated: true, completion: nil)
    }
  }
}

//MARK: UITableView
extension UITableView {
  /// check for last visible cell in the table view
  ///
  /// - Parameter indexPath: indexPath of table view
  func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
    guard let lastIndexPath = indexPathsForVisibleRows?.last else {
      return false
    }
    
    return lastIndexPath == indexPath
  }
}
