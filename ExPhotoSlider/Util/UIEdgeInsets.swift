//
//  UIEdgeInsets.swift
//  ExPhotoSlider
//
//  Created by Jake.K on 2021/12/15.
//

import UIKit

extension UIEdgeInsets {
  var horizontalInsets: CGFloat { self.left + self.right }
  var verticalInsets: CGFloat { self.top + self.bottom }
  
  init(_ all: CGFloat) {
    self = UIEdgeInsets(top: all, left: all, bottom: all, right: all)
  }
  
  init(horizontal: CGFloat, vertical: CGFloat) {
    self = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }
  
  static func with(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
    UIEdgeInsets(
      top: top,
      left: left,
      bottom: bottom,
      right: right
    )
  }
  
  static func horizontal(_ horizontal: CGFloat, top: CGFloat = 0, bottom: CGFloat = 0) -> UIEdgeInsets {
    UIEdgeInsets(
      top: top,
      left: horizontal,
      bottom: bottom,
      right: horizontal
    )
  }
  
  static func vertical(_ vertical: CGFloat, left: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
    UIEdgeInsets(
      top: vertical,
      left: left,
      bottom: vertical,
      right: right
    )
  }
  
  func with(left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil) -> UIEdgeInsets {
    UIEdgeInsets(
      top: top ?? self.top,
      left: left ?? self.left,
      bottom: bottom ?? self.bottom,
      right: right ?? self.right
    )
  }
  
  func with(horizontal: CGFloat, top: CGFloat? = nil, bottom: CGFloat? = nil) -> UIEdgeInsets {
    UIEdgeInsets(
      top: top ?? self.top,
      left: horizontal,
      bottom: bottom ?? self.bottom,
      right: horizontal
    )
  }
  
  func with(vertical: CGFloat, left: CGFloat? = nil, right: CGFloat? = nil) -> UIEdgeInsets {
    UIEdgeInsets(
      top: vertical,
      left: left ?? self.left,
      bottom: vertical,
      right: right ?? self.right
    )
  }
}
