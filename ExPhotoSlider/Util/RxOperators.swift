//
//  RxOperators.swift
//  ExPhotoSlider
//
//  Created by Jake.K on 2021/12/14.
//

import RxSwift
import RxCocoa

// MARK: - map()
extension ObservableType {
  func map<T>(_ element: T) -> Observable<T> {
    self.map({ _ in element })
  }
  func map<T>(_ element: @escaping () -> T) -> Observable<T> {
    self.map({ _ in element() })
  }
}

extension SharedSequence {
  func map<T>(_ element: T) -> SharedSequence<SharingStrategy, T> {
    self.map({ _ in element })
  }
  func map<T>(_ element: @escaping () -> T) -> SharedSequence<SharingStrategy, T> {
    self.map({ _ in element() })
  }
}
