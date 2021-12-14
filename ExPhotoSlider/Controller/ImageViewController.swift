//
//  ImageViewController.swift
//  ExSlider
//
//  Created by Jake.K on 2021/12/14.
//

import UIKit
import SnapKit
import Then
import Reusable
import RxDataSources
import RxSwift
import RxCocoa

class ImageViewController: UIViewController {
  // MARK: Constant
  private enum Metric {
    static let collectionViewItemSize = CGSize(
      width: (UIScreen.main.bounds.width - 32.0 - Self.collectionViewSpacing) / 3.0,
      height: 96.0
    )
    static let collectionViewSpacing = 8.0
    static let collectionViewContentInset = UIEdgeInsets(
      top: 4.0,
      left: 4.0,
      bottom: 4.0,
      right: 4.0
    )
  }
  
  private enum Color {
    static let clear = UIColor.clear
    static let white = UIColor.white
  }
  
  // MARK: UI
  private let imageCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.itemSize = Metric.collectionViewItemSize
      $0.minimumLineSpacing = Metric.collectionViewSpacing
      $0.minimumInteritemSpacing = Metric.collectionViewSpacing
    }
  ).then {
    $0.register(cellType: ImageCollectionViewCell.self)
    $0.contentInset = Metric.collectionViewContentInset
    $0.showsHorizontalScrollIndicator = false
    $0.allowsSelection = true
    $0.isScrollEnabled = true
    $0.bounces = true
    $0.backgroundColor = Color.clear
  }
  
  // MARK: Properties
  private var randomImageProvider: RandomImageProviderType!
  private var imageDataSource = BehaviorRelay<[ImageSection]>(value: [])
  private let disposeBag = DisposeBag()
  
  // MARK: DataSources
  private static func configureCollectionViewCell(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    item: ImageSectionItem
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(for: indexPath) as ImageCollectionViewCell
    switch item {
    case .main(let imageItem):
      cell.setImage(imageItem.image)
    }
    return cell
  }
  
  // MARK: ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupViews()
    self.injectDependency()
    self.configureLayout()
    self.setupCollectionViewDataSource()
    self.configureBind()
    self.loadImage()
  }
  
  private func setupViews() {
    self.view.backgroundColor = Color.white
  }
  
  private func injectDependency() {
    self.randomImageProvider = RandomImageProducer()
  }
  
  private func configureLayout() {
    view.addSubview(self.imageCollectionView)
    self.imageCollectionView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func setupCollectionViewDataSource() {
    let collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<ImageSection> { dataSource, collectionView, indexPath, item in
      Self.configureCollectionViewCell(
        collectionView: collectionView,
        indexPath: indexPath,
        item: item
      )
    }
    
    self.imageDataSource
      .bind(to: self.imageCollectionView.rx.items(dataSource: collectionViewDataSource))
      .disposed(by: self.disposeBag)
  }
  
  private func configureBind() {
    self.imageCollectionView.rx.itemSelected
      .bind(onNext: { indexPath in
        print("did Tap indexPath \(indexPath)")
      })
      .disposed(by: disposeBag)
  }
  
  private func loadImage() {
    self.randomImageProvider
      .getRandomColorImages(number: 30)
      .asObservable()
      .map { images -> [ImageSection] in
        let imageSectionItems = images.map { image -> ImageSectionItem in
          let imageSectionItem = ImageSectionItem.main(Image(image: image))
          return imageSectionItem
        }
        let imageSections = ImageSection.main(imageSectionItems)
        return [imageSections]
      }
      .bind(onNext: imageDataSource.accept)
      .disposed(by: disposeBag)
  }
}
