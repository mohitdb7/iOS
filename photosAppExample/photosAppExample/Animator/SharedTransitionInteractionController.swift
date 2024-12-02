//
//  SharedTransitionInteractionController.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

enum Direction {
    case horizontal
    case vertical
}

class SharedTransitionInteractionController: NSObject {
    // 1
    struct Context {
        var transitionContext: UIViewControllerContextTransitioning
        var fromFrame: CGRect
        var toFrame: CGRect
        var fromView: UIView
        var toView: UIView
        var mask: UIView
        var transform: CGAffineTransform
        var overlay: UIView
        var placeholder: UIView
    }
    // 2
    private var context: Context?
}

extension SharedTransitionInteractionController {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // 1
        guard let (fromView, fromFrame, toView, toFrame) = setup(with: transitionContext) else {
            transitionContext.completeTransition(false)
            return
        }
        // 2
        let transform: CGAffineTransform = .transform(
            parent: fromView.frame,
            soChild: fromFrame,
            aspectFills: toFrame
        )
        
        let mask = UIView(frame: fromView.frame).then {
            $0.layer.cornerCurve = .continuous
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 39
        }
        fromView.mask = mask
        let placeholder = UIView().then {
            $0.frame = toFrame
            $0.backgroundColor = .white
        }
        toView.addSubview(placeholder)
        let overlay = UIView().then {
            $0.backgroundColor = .black
            $0.layer.opacity = 0.5
            $0.frame = toView.frame
        }
        toView.addSubview(overlay)
        // 3
        context = Context(
            transitionContext: transitionContext,
            fromFrame: fromFrame,
            toFrame: toFrame,
            fromView: fromView,
            toView: toView,
            mask: mask,
            transform: transform,
            overlay: overlay,
            placeholder: placeholder
        )
    }
    
    // 1
    func update(_ recognizer: UIPanGestureRecognizer, direction: Direction) -> CGFloat {
        guard let context else { return .zero }
        // 2
        let window = UIApplication.keyWindow!
        let translation = recognizer.translation(in: window)
        let progress = direction == .horizontal ?
        (translation.x / window.frame.width) :
        (translation.y / window.frame.height)
        
        // 3
        context.transitionContext.updateInteractiveTransition(progress)
        // 4
        var scaleFactor = 1 - abs(progress * 0.4)
        scaleFactor = min(max(scaleFactor, 0.6), 1)
        // 5
        context.fromView.transform = .init(scaleX: scaleFactor, y: scaleFactor)
            .translatedBy(x: translation.x, y: translation.y)
        
        return scaleFactor
    }
    
    func cancel() {
        guard let context else { return }
        // 1
        context.transitionContext.cancelInteractiveTransition()
        // 2
        UIView.animate(withDuration: 0.25) {
            context.fromView.transform = .identity
            context.mask.frame = context.fromView.frame
            context.mask.layer.cornerRadius = 39
            context.overlay.layer.opacity = 0.5
        } completion: { _ in
            // 3
            context.overlay.removeFromSuperview()
            context.placeholder.removeFromSuperview()
            context.toView.removeFromSuperview()
            // 4
            context.transitionContext.completeTransition(false)
        }
    }
    
    func finish() {
        guard let context else { return }
        // 1
        context.transitionContext.finishInteractiveTransition()
        // 2
        let maskFrame = context.toFrame.aspectFit(to: context.fromFrame)
        UIView.animate(withDuration: 0.25) {
            context.fromView.transform = context.transform
            context.mask.frame = maskFrame
            context.mask.layer.cornerRadius = 0
            context.overlay.layer.opacity = 0
        } completion: { _ in
            // 3
            context.overlay.removeFromSuperview()
            context.placeholder.removeFromSuperview()
            context.transitionContext.completeTransition(true)
        }
    }

}

extension SharedTransitionInteractionController {
    private func prepareViewController(from context: UIViewControllerContextTransitioning) {
        let toVC = context.viewController(forKey: .to) as? SharedTransitioning
        toVC?.prepare(for: .pop)
    }
    
    private func setup(with context: UIViewControllerContextTransitioning) -> (UIView, CGRect, UIView, CGRect)? {
        guard let toView = context.view(forKey: .to),
              let fromView = context.view(forKey: .from) else {
            return nil
        }
        context.containerView.insertSubview(toView, belowSubview: fromView)
        guard let toFrame = context.sharedFrame(forKey: .to),
              let fromFrame = context.sharedFrame(forKey: .from) else {
            return nil
        }
        return (fromView, fromFrame, toView, toFrame)
    }
}

extension SharedTransitionInteractionController: UIViewControllerInteractiveTransitioning {
    
}
