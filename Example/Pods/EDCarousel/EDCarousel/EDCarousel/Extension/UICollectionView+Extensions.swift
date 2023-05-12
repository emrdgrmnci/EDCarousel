//
//  UICollectionView+Extensions.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 9.05.2023.
//

import Foundation
import UIKit.UICollectionView

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_ type: T.Type) {
        let className = String(describing: type)
        register(type, forCellWithReuseIdentifier: className)
    }

    public func registerNib<T: UICollectionViewCell>(_ type: T.Type, bundle: Bundle? = nil) {
        let className = String(describing: type)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }

    public func dequeue<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        let className = String(describing: type)
        guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else {
            debugPrint("The dequeued cell is not an instance of \(className).")
            return nil
        }
        return cell
    }
}
