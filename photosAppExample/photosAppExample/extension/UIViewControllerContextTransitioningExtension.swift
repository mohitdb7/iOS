//
//  UIViewControllerContextTransitioningExtension.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

extension UIViewControllerContextTransitioning {
    func sharedFrame(forKey key: UITransitionContextViewControllerKey) -> CGRect? {
        let vc = viewController(forKey: key)
        vc?.view.layoutIfNeeded()
        return (vc as? SharedTransitioning)?.sharedFrame
    }
}
