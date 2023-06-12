//
//  UICollectionView+Extensions.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 9.05.2023.
//

import Foundation
import UIKit.UICollectionView

/// This extension provides convenience methods for registering and dequeuing cells in a collection view.
/// These methods simplify the process of working with collection view cells.
extension UICollectionView {
    
    /// The register(_:) method registers a cell class with the collection view by using the cell class itself as the identifier. This method is useful when the cell class is not defined in a separate nib file.
    /// - Parameter type: The generic cell class to register with the collection view.
    public func register<T: UICollectionViewCell>(_ type: T.Type) {
        let className = String(describing: type)
        register(type, forCellWithReuseIdentifier: className)
    }
    
    /// The registerNib(_:) method registers a cell class with the collection view by using a nib file.
    /// This method is useful when the cell class is defined in a separate nib file.
    /// - Parameters:
    ///   - type: The cell class to register with the collection view.
    ///   - bundle: An optional bundle parameter that specifies the bundle where the nib file is located.
    ///   If not provided, the main bundle is used.
    public func registerNib<T: UICollectionViewCell>(_ type: T.Type, bundle: Bundle? = nil) {
        let className = String(describing: type)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    /// The dequeue(_:) method dequeues a reusable cell from the collection view for the specified index path.
    /// - Parameters:
    ///   - type: The cell class to dequeue from the collection view.
    ///   - indexPath: The index path of the cell to dequeue.
    /// - Returns: The dequeued cell casted to the specified cell class, or nil if the dequeued cell is not an instance of the specified class.
    public func dequeue<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        let className = String(describing: type)
        guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else {
            debugPrint("The dequeued cell is not an instance of \(className).")
            return nil
        }
        return cell
    }
}
