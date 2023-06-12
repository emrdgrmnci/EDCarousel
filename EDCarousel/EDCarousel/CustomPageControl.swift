//
//  CustomPageControl.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 9.05.2023.
//

import Foundation
import UIKit

/// The CustomPageControl class is a subclass of UIPageControl that provides customization options for the appearance of page control dots.
/// This documentation will explain the purpose and functionality of each component of the code.
public class CustomPageControl: UIPageControl {
    /// An optional image to be displayed for the current page dot.
   public var currentPageImage: UIImage?
    /// An optional image to be displayed for the dots of other pages.
    public var otherPagesImage: UIImage?
    
    /// This property represents the total number of pages.
    /// When this property is set, the updateDots() method is called to update the appearance of the page control dots.
    public override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    /// This property represents the index of the currently displayed page.
    /// When this property is set, the updateDots() method is called to update the appearance of the page control dots.
    public override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    /// This method is called when the page control is created from a storyboard or nib file.
    /// In this implementation, the method sets the page indicator and current page indicator tint colors, and sets the clipsToBounds property to false to prevent the dots from being clipped.
    public override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            pageIndicatorTintColor = .black
            currentPageIndicatorTintColor = .green
            clipsToBounds = false
        }
    }
    
    /// This method provides the default configuration for iOS 14 and above.
    /// It sets the indicator image for each page based on the current page index.
    /// The pageIndicatorTintColor is set to gray, and the currentPageIndicatorTintColor is set to green.
    public func defaultConfigurationForiOS14AndAbove() {
        if #available(iOS 14.0, *) {
            for index in 0 ..< numberOfPages {
                let image = index == currentPage ? currentPageImage : otherPagesImage
                setIndicatorImage(image, forPage: index)
            }
            pageIndicatorTintColor = .gray
            currentPageIndicatorTintColor = .green
        }
    }
    
    /// This method updates the appearance of the page control dots based on the current page index and number of pages.
    /// If the iOS version is 14 or above, it calls defaultConfigurationForiOS14AndAbove() to apply the default configuration.
    /// Otherwise, it iterates over the subviews of the page control and sets the appropriate image for each dot.
    public func updateDots() {
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            for (index, subview) in subviews.enumerated() {
                let imageView: UIImageView
                if let existingImageview = getImageView(forSubview: subview) {
                    imageView = existingImageview
                } else {
                    imageView = UIImageView(image: otherPagesImage)
                    imageView.center = subview.center
                    subview.addSubview(imageView)
                    subview.clipsToBounds = false
                }
                imageView.image = currentPage == index ? currentPageImage : otherPagesImage
            }
        }
    }
    
    /// This method retrieves the UIImageView associated with a given subview of the page control.
    /// If the subview itself is an instance of UIImageView, it is returned.
    /// Otherwise, the first subview that is an instance of UIImageView is returned.
    /// - Parameter view: A given subview of the page control.
    /// - Returns: Subview instance of an UIImageView.
    public func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { view -> Bool in
                view is UIImageView
            } as? UIImageView

            return view
        }
    }
}
