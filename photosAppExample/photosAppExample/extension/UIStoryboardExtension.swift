//
//  UIStoryboardExtension.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 06/08/24.
//

import UIKit

enum StoryboardName: String, CaseIterable {
    case main = "Main"
    case instagram = "Instagram"
}

extension UIStoryboard {
    static func getViewController<T: UIViewController>(fromStoryboard name: String = StoryboardName.main.rawValue, controllerIdentifier identifier: T.Type) -> T? {
        if let footballHomeVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            return footballHomeVC
        }
        return nil
    }
}
