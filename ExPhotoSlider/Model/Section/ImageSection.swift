//
//  ImageSection.swift
//  ExPhotoSlider
//
//  Created by Jake.K on 2021/12/14.
//

import RxDataSources

enum ImageSection {
  case main([ImageSectionItem])
}

extension ImageSection: SectionModelType {
  var items: [ImageSectionItem] {
    switch self {
    case .main(let images):
      return images
    }
  }
  
  init(original: ImageSection, items: [ImageSectionItem]) {
    switch original {
    case .main:
      self = .main(items)
    }
  }
}

extension ImageSection: Equatable {
  static func == (lhs: ImageSection, rhs: ImageSection) -> Bool {
    lhs.items == rhs.items
  }
}

enum ImageSectionItem: Equatable {
  case main(Image)
}
