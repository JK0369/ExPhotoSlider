//
//  RandomImageProducer.swift
//  ExSlider
//
//  Created by Jake.K on 2021/12/14.
//

import UIKit
import RxSwift

protocol RandomImageProviderType {
  func getRandomColorImages(number: Int) -> Single<[UIImage]>
}

struct RandomImageProducer: RandomImageProviderType {
  func getRandomColorImages(number: Int) -> Single<[UIImage]> {
    let images = (1...number).compactMap { _ in getRandomeImage() }
    return .just(images)
  }
  
  private func getRandomeImage() -> UIImage {
    getRandomColor().asImage()
  }
  
  private func getRandomColor() -> UIColor{
    let randomRed = CGFloat(drand48())
    let randomGreen = CGFloat(drand48())
    let randomBlue = CGFloat(drand48())
    return UIColor(
      red: randomRed,
      green: randomGreen,
      blue: randomBlue,
      alpha: 1.0
    )
  }
}
