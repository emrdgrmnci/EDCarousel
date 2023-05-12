//
//  CarouselFlowLayout.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 9.05.2023.
//

import UIKit

public enum CarouselFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}

public class CarouselFlowLayout: UICollectionViewFlowLayout {
   public struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
        func isEqual(_ otherState: LayoutState) -> Bool {
            return size.equalTo(otherState.size) && direction == otherState.direction
        }
    }

    public var sideItemScale: CGFloat = 0.8
    public var sideItemAlpha: CGFloat = 0.8
    public var sideItemShift: CGFloat = 0.8
    public var spacingMode = CarouselFlowLayoutSpacingMode.fixed(spacing: 10)

    public var state = LayoutState(size: CGSize.zero, direction: .horizontal)

    public override func prepare() {
        super.prepare()
        let currentState = LayoutState(size: collectionView!.bounds.size, direction: scrollDirection)

        if !state.isEqual(currentState) {
            setupCollectionView()
            updateLayout()
            state = currentState
        }
    }

    public func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }

    public func updateLayout() {
        guard let collectionView = collectionView else { return }

        let collectionSize = collectionView.bounds.size
        let isHorizontal = (scrollDirection == .horizontal)

        let yInset = (collectionSize.height - itemSize.height) / 2
        let xInset = (collectionSize.width - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)

        let side = isHorizontal ? itemSize.width : itemSize.height
        let scaledItemOffset = (side - side * sideItemScale) / 2
        switch spacingMode {
        case let .fixed(spacing):
            minimumLineSpacing = spacing - scaledItemOffset
        case let .overlap(visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
            let inset = isHorizontal ? xInset : yInset
            minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }

    public override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        return true
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return nil }
        return attributes.map { self.transformLayoutAttributes($0) }
    }

    public func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return attributes }
        let isHorizontal = (scrollDirection == .horizontal)

        let collectionCenter = isHorizontal ? collectionView.frame.size.width / 2 : collectionView.frame.size.height / 2
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset

        let maxDistance = (isHorizontal ? itemSize.width : itemSize.height) + minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance) / maxDistance

        let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
        let scale = ratio * (1 - sideItemScale) + sideItemScale
        let shift = (1 - ratio) * sideItemShift
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)

        if isHorizontal {
            attributes.center.y += shift
        } else {
            attributes.center.x += shift
        }
        return attributes
    }

    public override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity _: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView, !collectionView.isPagingEnabled,
              let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
        else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        scrollDirection = .horizontal

        let midSide = collectionView.bounds.size.width / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + midSide

        var targetContentOffset: CGPoint
        let closest = layoutAttributes
            .sorted {
                abs($0.center.x - proposedContentOffsetCenterOrigin) <
                    abs($1.center.x - proposedContentOffsetCenterOrigin)
            }
            .first ?? UICollectionViewLayoutAttributes()
        targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        return targetContentOffset
    }
}

