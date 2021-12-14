//
//  RxDataSource+Indexable.swift
//  ExPhotoSlider
//
//  Created by Jake.K on 2021/12/14.
//

import RxDataSources

protocol ItemIndexable {
  associatedtype Item
  
  subscript(indexPath: IndexPath) -> Item { get set }
}

extension ItemIndexable {
  func item(at index: IndexPath) throws -> Item { self[index] }
  func items(at indexes: [IndexPath]) throws -> [Item] { try indexes.map(self.item(at:)) }
}

extension TableViewSectionedDataSource: ItemIndexable { }
extension CollectionViewSectionedDataSource: ItemIndexable { }
