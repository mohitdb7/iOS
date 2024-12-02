//
//  PostListViewController.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

class PostListViewController: UIViewController {
    private enum Constants {
        static let numberOfColumns = 3
        static let sectionInset: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        static let interItemSpacing: CGFloat = 2
        static let lineSpacing: CGFloat = 2
    }
    
    var photos: [UIImage]!
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        $0.sectionInset = Constants.sectionInset
        $0.minimumLineSpacing = Constants.lineSpacing
        $0.minimumInteritemSpacing = Constants.interItemSpacing
    }
    
    private var selectedIndexPath: IndexPath? = nil
    @IBOutlet weak var postsCollectionView: UICollectionView!
    private let transitionAnimator = SharedTransitionAnimator()
    
    private func setupCollectionView() {
        postsCollectionView.registerCell(ofType: PostListCollectionViewCell.self)
        
        postsCollectionView.collectionViewLayout = layout
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
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
        
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
}

extension PostListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostListCollectionViewCell.identifier, for: indexPath) as? PostListCollectionViewCell {
            cell.imageView.image = photos[indexPath.row]
            return cell
        }
        
        fatalError("Unidentified cell to render")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let item = photos[indexPath.row]
        if let vc = UIStoryboard.getViewController(fromStoryboard: StoryboardName.instagram.rawValue, controllerIdentifier: PostsDetailListViewController.self) {
            vc.image = photos[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PostListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacingWidth = CGFloat(Constants.numberOfColumns - 1) * Constants.interItemSpacing
        let contentWidth = collectionView.frame.inset(by: Constants.sectionInset).width
        let availableWidth = contentWidth - spacingWidth
        let size = availableWidth / CGFloat(Constants.numberOfColumns)
        
        return CGSize(width: size, height: size)
    }
}

extension PostListViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if fromVC is Self, toVC is PostsDetailListViewController {
                transitionAnimator.transition = .push
                return transitionAnimator
            }
            if toVC is Self, fromVC is PostsDetailListViewController {
                transitionAnimator.transition = .pop
                return transitionAnimator
            }
            return nil
        }
}

extension PostListViewController: SharedTransitioning {
    var sharedFrame: CGRect {
        guard let selectedIndexPath,
              let cell = postsCollectionView.cellForItem(at: selectedIndexPath),
              let frame = cell.frameInWindow else {
            return .zero
        }
        
        return frame
    }
    
    func prepare(for transition: SharedTransitionAnimator.Transition) {
        guard transition == .pop, let selectedIndexPath else { return }
        postsCollectionView.verticalScrollItemVisible(at: selectedIndexPath, with: 40, animated: false)
    }
}


