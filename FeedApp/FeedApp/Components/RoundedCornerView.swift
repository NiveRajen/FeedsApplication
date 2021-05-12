//
//  RoundedCornerView.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import UIKit

//MARK: ROUNDEDCORNER VIEW
@IBDesignable
public class RoundedCornerView: UIView {
  
  //Top left radius
  @IBInspectable
  open var topLeftRadius: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }
  
  //Top right radius
  @IBInspectable
  open var topRightRadius: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }
  
  //Bottom left radius
  @IBInspectable
  open var bottomLeftRadius: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }
  
  //Bottom right radius
  @IBInspectable
  open var bottomRightRadius: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }
  
  ///Applying mask for the various edge of the view with different radius
  private func applyRadiusMaskFor() {
    let path = UIBezierPath(shouldRoundRect: bounds,
                            topLeftRadius: CGSize(width: topLeftRadius, height: topLeftRadius),
                            topRightRadius: CGSize(width: topRightRadius, height: topRightRadius),
                            bottomLeftRadius: CGSize(width: bottomLeftRadius, height: bottomLeftRadius),
                            bottomRightRadius: CGSize(width: bottomRightRadius, height: bottomRightRadius))
    let shape = CAShapeLayer()
    shape.path = path.cgPath
    layer.mask = shape
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    
    applyRadiusMaskFor()
    self.addGradientLayer(with: .MagentoColor, and: .Honey)
  }
}
