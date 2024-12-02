//
//  SharedTransition.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 09/08/24.
//

import UIKit

protocol SharedTransitioning {
    var sharedFrame: CGRect { get }
    var config: SharedTransitionConfig? { get }
    func prepare(for transition: SharedTransitionAnimator.Transition)
}

extension SharedTransitioning {
    var config: SharedTransitionConfig? {
        nil
    }
    
    func prepare(for transition: SharedTransitionAnimator.Transition) {
        
    }
}

public struct SharedTransitionConfig {
    var duration: CGFloat
    var curve: CAMediaTimingFunction
    var maskCornerRadius: CGFloat
    var overlayOpacity: Float
    var interactionScaleFactor: CGFloat = .zero
    var placeholderColor: UIColor
}

extension SharedTransitionConfig {
    static var `default`: SharedTransitionConfig {
        .init(
            duration: 0.25,
            curve: CAMediaTimingFunction(controlPoints: 0.5, 0, 0.6, 1),
            maskCornerRadius: 39,
            overlayOpacity: 0.5,
            placeholderColor: .white
        )
    }

    static var interactive: SharedTransitionConfig {
        .init(
            duration: 0.25,
            curve: CAMediaTimingFunction(controlPoints: 0.57, 0.27, 0.21, 0.97),
            maskCornerRadius: 39,
            overlayOpacity: 0.5,
            interactionScaleFactor: 0.6,
            placeholderColor: .white
        )
    }
}
