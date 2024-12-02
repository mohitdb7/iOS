//
//  DetailListViewController.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

class PostsDetailListViewController: UIViewController {
    
    var image: UIImage!
    var detailView: DetailItemView!
    
    private let transitionAnimator = SharedTransitionAnimator()
    private var interactionController: SharedTransitionInteractionController?
    
    private lazy var recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    
    var prevScaleFactor: CGFloat = 0.0
    var shouldDismiss = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detailView = Bundle.main.loadNibNamed("\(DetailItemView.self)", owner: self)?.first as? DetailItemView {
            self.detailView = detailView
            detailView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(detailView)
            
            detailView.detailImage.image = image
            
            NSLayoutConstraint.activate([
                detailView.topAnchor.constraint(equalTo: view.topAnchor),
                detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
        
        navigationController?.delegate = self
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let window = UIApplication.keyWindow!
        // 2
        switch recognizer.state {
        case .began:
            // 3
            let velocity = recognizer.velocity(in: window)
            guard abs(velocity.x) > abs(velocity.y) else { return }
            // 4
            interactionController = SharedTransitionInteractionController()
            navigationController?.popViewController(animated: true)
        case .changed:
            let newScaleFactor = interactionController?.update(recognizer, direction: .horizontal) ?? .zero
            if (newScaleFactor - prevScaleFactor) < 0 && newScaleFactor < 0.9 {
                shouldDismiss = true
            } else {
                shouldDismiss = false
            }
            prevScaleFactor = newScaleFactor
        case .ended:
            if shouldDismiss {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            
            interactionController = nil
        default:
            interactionController?.cancel()
            interactionController = nil
        }
    }
}

extension PostsDetailListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard fromVC is Self, toVC is PostListViewController else {
            return nil
        }
        
        transitionAnimator.transition = .pop
        return transitionAnimator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactionController
    }
}

extension PostsDetailListViewController: SharedTransitioning {
    var sharedFrame: CGRect {
        detailView.detailImage.frameInWindow ?? .zero
    }
}
