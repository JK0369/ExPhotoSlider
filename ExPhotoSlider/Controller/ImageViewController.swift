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
    private static let numberOfRows = 3.0
    static let collectionViewItemSize = CGSize(
      width: (
        UIScreen.main.bounds.width - collectionViewSpacing * (numberOfRows + 1) - Self.collectionViewSpacing
      ) / numberOfRows,
      height: 96.0
    )
    static let collectionViewSpacing = 4.0
    static let collectionViewContentInset = UIEdgeInsets(4.0)
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
    
    self.imageCollectionView.rx.itemSelected
      .map(collectionViewDataSource.item)
      .map(self.getDetailImageCount(imageSectionItem:))
      .bind(onNext: self.presentDetailViewController(detailImageCount:))
      .disposed(by: self.disposeBag)
  }
  
  private func getDetailImageCount(imageSectionItem: ImageSectionItem) -> Int {
    switch imageSectionItem {
    case .main(let image):
      return image.detailImageCount
    }
  }
  
  private func presentDetailViewController(detailImageCount: Int) {
    let detailViewController = DetailViewController(detailImageCount: detailImageCount)
    present(detailViewController, animated: true)
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
