//
//  PhotosDetailViewController.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 06/08/24.
//

import UIKit

protocol PhotosDetailViewControllerDelegate: AnyObject {
    func containerViewController(_ containerViewController: PhotosDetailViewController, indexDidUpdate currentIndex: Int)
}

class PhotosDetailViewController: UIViewController {

    var photos: [UIImage]!
    var currentIndex = 0
    var nextIndex: Int?
    
    weak var delegate: PhotosDetailViewControllerDelegate?
    
    private let transitionAnimator = SharedTransitionAnimator()
    private var interactionController: SharedTransitionInteractionController?
    private lazy var recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    
    var prevScaleFactor: CGFloat = 0.0
    var shouldDismiss = true
    
    var pageViewController: UIPageViewController {
        return self.children[0] as! UIPageViewController
    }
    
    var currentViewController: PhotoViewController {
        return self.pageViewController.viewControllers![0] as! PhotoViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if photos == nil {
            self.photos = [
                #imageLiteral(resourceName: "1"),
                #imageLiteral(resourceName: "2"),
                #imageLiteral(resourceName: "3"),
                #imageLiteral(resourceName: "4"),
                #imageLiteral(resourceName: "5"),
                #imageLiteral(resourceName: "6"),
                #imageLiteral(resourceName: "7"),
                #imageLiteral(resourceName: "8"),
                #imageLiteral(resourceName: "9"),
                #imageLiteral(resourceName: "10"),
                #imageLiteral(resourceName: "11"),
                #imageLiteral(resourceName: "12"),
                #imageLiteral(resourceName: "13"),
                #imageLiteral(resourceName: "14"),
                #imageLiteral(resourceName: "15"),
                #imageLiteral(resourceName: "16"),
                #imageLiteral(resourceName: "17"),
                #imageLiteral(resourceName: "18")]
            /*
                #imageLiteral(resourceName: "1"),
                #imageLiteral(resourceName: "2"),
                #imageLiteral(resourceName: "3"),
                #imageLiteral(resourceName: "4"),
                #imageLiteral(resourceName: "5"),
                #imageLiteral(resourceName: "6"),
                #imageLiteral(resourceName: "7"),
                #imageLiteral(resourceName: "8"),
                #imageLiteral(resourceName: "9"),
                #imageLiteral(resourceName: "10"),
                #imageLiteral(resourceName: "11"),
                #imageLiteral(resourceName: "12"),
                #imageLiteral(resourceName: "13"),
                #imageLiteral(resourceName: "14"),
                #imageLiteral(resourceName: "15"),
                #imageLiteral(resourceName: "16"),
                #imageLiteral(resourceName: "17"),
                #imageLiteral(resourceName: "18")
            ]*/
        }
        
        if let pageViewController = UIStoryboard.getViewController(controllerIdentifier: PhotosDetailPageViewController.self) {
            self.addChild(pageViewController)
            
            pageViewController.view.frame = view.frame
            self.view.addSubview(pageViewController.view)
            
            pageViewController.delegate = self
            pageViewController.dataSource = self
            
            setupViewController()
        }
        
        navigationController?.delegate = self
        view.addGestureRecognizer(recognizer)
    }
    
    func setupViewController() {
        if let vc = UIStoryboard.getViewController(controllerIdentifier: PhotoViewController.self) {
            vc.image = self.photos[currentIndex]
            vc.index = currentIndex
            let vcs = [vc]
            pageViewController.setViewControllers(vcs, direction: .forward, animated: true)
        }
    }
}

extension PhotosDetailViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentIndex == 0 {
            return nil
        }
        
        if let vc = UIStoryboard.getViewController(controllerIdentifier: PhotoViewController.self) {
            vc.image = self.photos[currentIndex - 1]
            vc.index = currentIndex - 1
            return vc
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentIndex == (self.photos.count - 1) {
            return nil
        }
        
        if let vc = UIStoryboard.getViewController(controllerIdentifier: PhotoViewController.self) {
            vc.image = self.photos[currentIndex + 1]
            vc.index = currentIndex + 1
            return vc
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vc = pendingViewControllers.first as? PhotoViewController else {
            return
        }
        
        nextIndex = vc.index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        currentIndex = nextIndex ?? currentIndex
        
        delegate?.containerViewController(self, indexDidUpdate: currentIndex)
    }
}

extension PhotosDetailViewController: SharedTransitioning {
    var sharedFrame: CGRect {
        currentViewController.photoImageView.frameInWindow ?? .zero
    }
}

extension PhotosDetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard fromVC is Self, toVC is PhotosCollectionViewController else {
            return nil
        }
        
        transitionAnimator.transition = .pop
        return transitionAnimator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactionController
    }
}

extension PhotosDetailViewController {
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let window = UIApplication.keyWindow!
        // 2
        switch recognizer.state {
        case .began:
            // 3
            let velocity = recognizer.velocity(in: window)
            guard abs(velocity.y) > abs(velocity.x) else { return }
            // 4
            interactionController = SharedTransitionInteractionController()
            navigationController?.popViewController(animated: true)
        case .changed:
            let newScaleFactor = interactionController?.update(recognizer, direction: .vertical) ?? .zero
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
