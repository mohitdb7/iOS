//
//  LandingTabBarViewController.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 09/08/24.
//

import UIKit

class LandingTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photosVC = UIStoryboard.getViewController(fromStoryboard: StoryboardName.main.rawValue, controllerIdentifier: PhotosCollectionViewController.self) {
            let navigationController = UINavigationController(rootViewController: photosVC)
            navigationController.title = "Photos"
            navigationController.tabBarItem.image = UIImage(systemName: "photo")
            
            if viewControllers == nil {
                viewControllers = [navigationController]
            } else {
                viewControllers?.append(navigationController)
            }
        }
        
        if let instaVC = UIStoryboard.getViewController(fromStoryboard: StoryboardName.instagram.rawValue, controllerIdentifier: PostListViewController.self) {
            let navigationController = UINavigationController(rootViewController: instaVC)
            navigationController.title = "Social"
            navigationController.tabBarItem.image = UIImage(systemName: "person.3.fill")
            
            if viewControllers == nil {
                viewControllers = [navigationController]
            } else {
                viewControllers?.append(navigationController)
            }
        }
    }

}
