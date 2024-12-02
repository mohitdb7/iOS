//
//  PhotoViewController.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 06/08/24.
//

import UIKit

class PhotoViewController: UIViewController {

    var image: UIImage!
    @IBOutlet weak var photoImageView: UIImageView!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = image
    }
}
