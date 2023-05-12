//
//  CustomPageControl.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 9.05.2023.
//

import Foundation
import UIKit

public class CustomPageControl: UIPageControl {
   public var currentPageImage: UIImage?
    public var otherPagesImage: UIImage?

    public override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }

    public override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

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
