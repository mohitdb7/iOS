//
//  SharedTransitionAnimator.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

class SharedTransitionAnimator: NSObject {
    let transitionSpeed: TimeInterval = 1.0
    enum Transition {
        case push
        case pop
    }
    
    var transition: Transition = .push
    private var config: SharedTransitionConfig = .default
}

extension SharedTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch transition {
        case .push:
            pushAnimation(context: transitionContext)
        case .pop:
            popAnimation(context: transitionContext)
        }
        
    }
}

extension SharedTransitionAnimator {
    private func setup(with context: UIViewControllerContextTransitioning) -> (UIView, CGRect, UIView, CGRect)? {
        // 1
        guard let toView = context.view(forKey: .to),
              let fromView = context.view(forKey: .from) else {
            return nil
        }
        // 2
        if transition == .push {
            context.containerView.addSubview(toView)
        } else {
            context.containerView.insertSubview(toView, belowSubview: fromView)
        }
        // 3
        guard let toFrame = context.sharedFrame(forKey: .to),
              let fromFrame = context.sharedFrame(forKey: .from) else {
            return nil
        }
        // 4
        return (fromView, fromFrame, toView, toFrame)
    }
    
    private func pushAnimation(context: UIViewControllerContextTransitioning) {
        // 1
        guard let (fromView, fromFrame, toView, toFrame) = setup(with: context) else {
            context.completeTransition(false)
            return
        }
        
        // 2
        let transform: CGAffineTransform = .transform(
            parent: toView.frame,
            soChild: toFrame,
            aspectFills: fromFrame
        )
        toView.transform = transform
        
        // 3
        let maskFrame = fromFrame.aspectFit(to: toFrame)
        let mask = UIView(frame: maskFrame).then {
            $0.layer.cornerCurve = .continuous
            $0.backgroundColor = .black
        }
        toView.mask = mask
        
        // 4
        let placeholder = UIView().then {
            $0.backgroundColor = config.placeholderColor
            $0.frame = fromFrame
        }
        fromView.addSubview(placeholder)
        
        // 5
        let overlay = UIView().then {
            $0.backgroundColor = .black
            $0.layer.opacity = 0
            $0.frame = fromView.frame
        }
        fromView.addSubview(overlay)
                
        UIView.animate(duration: config.duration, curve: config.curve) { [config] in
            toView.transform = .identity
            mask.frame = toView.frame
            mask.layer.cornerRadius = config.maskCornerRadius
            overlay.layer.opacity = config.overlayOpacity
        } completion: {
            toView.mask = nil
            overlay.removeFromSuperview()
            placeholder.removeFromSuperview()
            context.completeTransition(true)
        }
    }
    
    private func popAnimation(context: UIViewControllerContextTransitioning) {
        // 1
        guard let (fromView, fromFrame, toView, toFrame) = setup(with: context) else {
            context.completeTransition(false)
            return
        }
        
        // 2
        let transform: CGAffineTransform = .transform(
            parent: fromView.frame,
            soChild: fromFrame,
            aspectFills: toFrame
        )
        // 3
        let mask = UIView(frame: fromView.frame).then {
            $0.layer.cornerCurve = .continuous
            $0.backgroundColor = .black
            $0.layer.cornerRadius = config.maskCornerRadius
        }
        fromView.mask = mask
        
        // 4
        let placeholder = UIView().then {
            $0.backgroundColor = config.placeholderColor
            $0.frame = toFrame
        }
        toView.addSubview(placeholder)
        
        // 5
        let overlay = UIView().then {
            $0.backgroundColor = .black
            $0.layer.opacity = config.overlayOpacity
            $0.frame = toView.frame
        }
        toView.addSubview(overlay)
        
        // 6
        let maskFrame = toFrame.aspectFit(to: fromFrame)
        UIView.animate(duration: config.duration, curve: config.curve) {
            fromView.transform = transform
            mask.frame = maskFrame
            mask.layer.cornerRadius = 0
            overlay.layer.opacity = 0
        } completion: {
            overlay.removeFromSuperview()
            placeholder.removeFromSuperview()
            let isCancelled = context.transitionWasCancelled
            context.completeTransition(!isCancelled)
        }
    }
}
