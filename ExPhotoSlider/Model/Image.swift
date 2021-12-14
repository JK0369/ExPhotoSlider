//
//  ImageItem.swift
//  ExPhotoSlider
//
//  Created by Jake.K on 2021/12/14.
//

import UIKit
import RxSwift

struct Image: ModelType {
  let image: UIImage
  private(set) var createdAt = Date().timeIntervalSince1970
  private(set) var detailImageCount = Int.random(in: 10..<20)
  
  init(image: UIImage) {
    self.image = image
  }
  
  static func == (lhs: Image, rhs: Image) -> Bool {
    lhs.createdAt == rhs.createdAt
  }
}
