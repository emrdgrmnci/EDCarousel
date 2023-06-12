//
//  CarouselFlowLayout.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 9.05.2023.
//

import UIKit

/// The CarouselFlowLayoutSpacingMode enumeration defines two spacing modes for the carousel flow layout:
public enum CarouselFlowLayoutSpacingMode {
    /// In this mode, the spacing between items is fixed, and the spacing parameter specifies the distance between adjacent items.
    case fixed(spacing: CGFloat)
    /// This mode allows items to overlap with each other. The visibleOffset parameter determines the amount of overlap between adjacent items.
    case overlap(visibleOffset: CGFloat)
}

/// The CarouselFlowLayout class inherits from UICollectionViewFlowLayout and implements the custom carousel layout.
public class CarouselFlowLayout: UICollectionViewFlowLayout {
    /// The LayoutState structure represents the state of the layout, including the size and scroll direction of the collection view.
    /// It is used to determine if the layout needs to be updated when the collection view's bounds or scroll direction change.
   public struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
        func isEqual(_ otherState: LayoutState) -> Bool {
            return size.equalTo(otherState.size) && direction == otherState.direction
        }
    }
    /// The scaling factor applied to the side items in the carousel. The default value is 0.8.
    public var sideItemScale: CGFloat = 0.8
    /// The opacity value of the side items. The default value is 0.8.
    public var sideItemAlpha: CGFloat = 0.8
    /// The horizontal or vertical shift applied to the side items. The default value is 0.8.
    public var sideItemShift: CGFloat = 0.8
    /// The spacing mode for the carousel layout. It determines how items are spaced and overlapped in the carousel. The default mode is .fixed(spacing: 10).
    public var spacingMode = CarouselFlowLayoutSpacingMode.fixed(spacing: 10)
    /// The current state of the layout, including the size and scroll direction of the collection view.
    public var state = LayoutState(size: CGSize.zero, direction: .horizontal)
    
    /// The prepare() method is called by the collection view before it updates its layout.
    /// This method checks if the current layout state has changed and updates the layout accordingly.
    /// If the state has changed, it calls the setupCollectionView() and updateLayout() methods.
    public override func prepare() {
        super.prepare()
        let currentState = LayoutState(size: collectionView!.bounds.size, direction: scrollDirection)

        if !state.isEqual(currentState) {
            setupCollectionView()
            updateLayout()
            state = currentState
        }
    }
    
    /// The setupCollectionView() method is responsible for configuring the collection view.
    /// It sets the deceleration rate of the collection view to .fast if it is not already set to that value.
    public func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }
    
    /// The updateLayout() method updates the layout attributes of the collection view items based on the current layout state.
    /// It calculates the insets, line spacing, and transforms for each item based on the chosen spacing mode.
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
    
    /// This method indicates whether the layout should be invalidated when the bounds of the collection view change. In this implementation, it always returns true.
    public override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        return true
    }
    
    /// This method returns the layout attributes for all items that intersect with the given rectangle.
    /// It retrieves the super attributes and transforms them using the transformLayoutAttributes(_:) method.
    /// - Parameter rect: Given rectangle.
    /// - Returns: Layout attributes for all items that intersect with the given rectangle.
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return nil }
        return attributes.map { self.transformLayoutAttributes($0) }
    }
    
    /// Method applies transformations to the layout attributes of each item in the collection view.
    /// It calculates the alpha, scale, shift, and zIndex values based on the item's position relative to the collection view center.
    /// These transformations create the carousel effect by scaling and shifting the items.
    /// - Parameter attributes: The layout attributes of each item in the collection view.
    /// - Returns: Layout attributes.
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
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = (attributes.frame.midX - visibleRect.midX)
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist / 1_000))
        attributes.transform3D = transform
        attributes.zIndex = Int(alpha * 10)

        if isHorizontal {
            attributes.center.y += shift
        } else {
            attributes.center.x += shift
        }
        return attributes
    }
    
    /// This method calculates the target content offset for the collection view when it finishes scrolling.
    /// It adjusts the content offset to center the nearest item.
    /// - Parameters:
    ///   - proposedContentOffset: Target content offset of item.
    /// - Returns: Coordinate system point of the item.
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

