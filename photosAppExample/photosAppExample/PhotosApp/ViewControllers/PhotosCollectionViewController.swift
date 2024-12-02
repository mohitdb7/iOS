//
//  ViewController.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 05/08/24.
//

import UIKit

private enum Constants {
    static let collectionViewContentInsets = UIEdgeInsets(top: 0, left: 4.0, bottom: 0, right: 4.0)
    static let numberOfColumns = 3
    static let minimumLineSpacing: CGFloat = 2.0
    static let minimumInteritemSpacing: CGFloat = 2.0
}

class PhotosCollectionViewController: UIViewController {
    var photos: [UIImage]!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    var selectedIndexPath: IndexPath!
    
    var currentLeftSafeAreaInset  : CGFloat = 0.0
    var currentRightSafeAreaInset : CGFloat = 0.0
    
    private let transitionAnimator = SharedTransitionAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
            #imageLiteral(resourceName: "18"),
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
        ]
        
        let nib = UINib(nibName: "\(PhotosCollectionViewCell.self)", bundle: nil)
        photosCollectionView.register(nib, forCellWithReuseIdentifier: "\(PhotosCollectionViewCell.self)")
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        photosCollectionView.contentInset = Constants.collectionViewContentInsets
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        photosCollectionView.collectionViewLayout = layout
        
        photosCollectionView.contentInset = Constants.collectionViewContentInsets
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        photosCollectionView.frame = self.view.frame
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if selectedIndexPath != nil {
            photosCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredVertically, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
    }
    
    override func viewSafeAreaInsetsDidChange() {
    
        //if the application launches in landscape mode, the safeAreaInsets
        //need to be updated from 0.0 if the device is an iPhone X model. At
        //application launch this function is called before viewWillLayoutSubviews()
        if #available(iOS 11, *) {
            
            self.currentLeftSafeAreaInset = self.view.safeAreaInsets.left
            self.currentRightSafeAreaInset = self.view.safeAreaInsets.right
        }
    }
}

extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let currentCell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotosCollectionViewCell.self)", for: indexPath) as? PhotosCollectionViewCell {
            currentCell.photoImage.image = photos[indexPath.row]
            
            return currentCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIStoryboard.getViewController(controllerIdentifier: PhotosDetailViewController.self) {
            vc.photos = photos
            vc.currentIndex = indexPath.row
            vc.delegate = self
            selectedIndexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacingWidth = CGFloat(Constants.numberOfColumns - 1) * Constants.minimumInteritemSpacing
        let contentWidth = collectionView.frame.inset(by: Constants.collectionViewContentInsets).width
        let availableWidth = contentWidth - spacingWidth
        let size = availableWidth / CGFloat(Constants.numberOfColumns)
        
        return CGSize(width: size, height: size)
    }
}

extension PhotosCollectionViewController: PhotosDetailViewControllerDelegate {
    func containerViewController(_ containerViewController: PhotosDetailViewController, indexDidUpdate currentIndex: Int) {
        self.selectedIndexPath = IndexPath(row: currentIndex, section: 0)
        photosCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredVertically, animated: false)
    }
}

extension PhotosCollectionViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is Self, toVC is PhotosDetailViewController {
            transitionAnimator.transition = .push
            return transitionAnimator
        }
        if toVC is Self, fromVC is PhotosDetailViewController {
            transitionAnimator.transition = .pop
            return transitionAnimator
        }
        return nil
    }
}

extension PhotosCollectionViewController: SharedTransitioning {
    var sharedFrame: CGRect {
        guard let selectedIndexPath,
              let cell = photosCollectionView.cellForItem(at: selectedIndexPath),
              let frame = cell.frameInWindow else {
            return .zero
        }
        
        return frame
    }
    
    func prepare(for transition: SharedTransitionAnimator.Transition) {
        guard transition == .pop, let selectedIndexPath else { return }
        photosCollectionView.verticalScrollItemVisible(at: selectedIndexPath, with: 40, animated: false)
    }
}
