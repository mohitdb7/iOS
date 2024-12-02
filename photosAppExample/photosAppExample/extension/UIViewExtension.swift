//
//  UIViewExtension.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

extension UIView {
    var frameInWindow: CGRect? {
        superview?.convert(frame, to: nil)
    }

    static func animate(
        duration: TimeInterval,
        curve: CAMediaTimingFunction? = nil,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(curve)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: animations,
            completion: { _ in completion?() }
        )
        CATransaction.commit()
    }
}
