//
//  ExampleCollectionDataSource.swift
//  Example
//
//  Created by Degirmenci Emre on 12.05.2023.
//

import Foundation
import UIKit
import EDCarousel

struct Onboarding {
    let color: UIColor
    let title: String
}

final class ExampleCollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    private var items = [Onboarding]()
    private weak var collectionView: UICollectionView?
    private weak var pageControl: UIPageControl?
    var scrollViewWillEndDragging: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void)?

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        set(collectionView: collectionView)
    }

    func updateData(items: [Onboarding]) {
        self.items = items
        collectionView?.reloadData()
    }

    // MARK: - Private

    private func set(collectionView: UICollectionView) {
        guard let layout = collectionView.collectionViewLayout as? CarouselFlowLayout else { return }
        let padding = 10.0
        layout.itemSize = CGSize(
            width: (collectionView.frame.size.width - padding) / 1.21,
            height: (collectionView.frame.size.width - padding) / 0.76
        )
        layout.spacingMode = CarouselFlowLayoutSpacingMode.overlap(visibleOffset: 200)
        layout.sideItemScale = 0.8
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.registerNib(ExampleCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(ExampleCollectionViewCell.self, for: indexPath) else {
            fatalError("UNABLE TO DEQUEUE CELL")
        }
        let item = items[indexPath.row]
        cell.set(item: item)
        return cell
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        scrollViewWillEndDragging?(scrollView, velocity, targetContentOffset)
    }
}
