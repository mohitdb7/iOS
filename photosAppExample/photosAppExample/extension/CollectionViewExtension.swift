//
//  CollectionViewExtension.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func registerCell<T>(ofType cell: T.Type, for bundle: Bundle? = nil) {
        let nib = UINib(nibName: "\(T.self)", bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: "\(T.self)")
    }
    
    func register<Cell: UICollectionViewCell>(_ type: Cell.Type) {
        register(type, forCellWithReuseIdentifier: Cell.identifier)
    }
    
    func dequeuCellOfType<Cell: UICollectionViewCell>(_ type: Cell.Type,
                                                      id: String? = nil,
                                                      for indexPath: IndexPath) -> Cell {
        let reuseIdentifier = id ?? Cell.identifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionView {
    enum VerticalScrollPosition {
        case top, bottom
    }

    enum VerticalCellPosition {
        case overTop
        case visible
        case overBottom
    }
    
    var visibleRect: CGRect {
        CGRect(origin: contentOffset, size: bounds.size)
    }

    var maxOffset: CGPoint {
        CGPoint(
            x: contentSize.width - bounds.size.width + safeAreaInsets.right + contentInset.right,
            y: contentSize.height - bounds.size.height + safeAreaInsets.bottom + contentInset.bottom
        )
    }

    var minOffset: CGPoint {
        CGPoint(
            x: -safeAreaInsets.left - contentInset.left,
            y: -safeAreaInsets.top - contentInset.top
        )
    }

    private func verticalCellPosition(for indexPath: IndexPath) -> VerticalCellPosition? {
        guard let attributes = layoutAttributesForItem(at: indexPath) else { return nil }
        if attributes.frame.minY < visibleRect.minY {
            return .overTop
        } else if attributes.frame.maxY > visibleRect.maxY {
            return .overBottom
        } else {
            return .visible
        }
    }

    func verticalScrollToItem(at indexPath: IndexPath,
                              at position: VerticalScrollPosition,
                              padding: CGFloat,
                              animated: Bool) {
        guard let attributes = layoutAttributesForItem(at: indexPath) else { return }
        switch position {
        case .top:
            var offset = attributes.frame.origin.y - padding
            offset = min(max(offset, minOffset.y), maxOffset.y)
            setContentOffset(.init(x: 0, y: offset), animated: animated)
        case .bottom:
            var offset = attributes.frame.origin.y - bounds.height + attributes.frame.height + padding
            offset = min(max(offset, minOffset.y), maxOffset.y)
            setContentOffset(.init(x: 0, y: offset), animated: animated)
        }
    }

    func verticalScrollItemVisible(at indexPath: IndexPath, with padding: CGFloat, animated: Bool) {
        switch verticalCellPosition(for: indexPath) {
        case .overTop:
            verticalScrollToItem(at: indexPath, at: .top, padding: padding, animated: animated)
        case .overBottom:
            verticalScrollToItem(at: indexPath, at: .bottom, padding: padding, animated: animated)
        default:
            return
        }
    }
}
