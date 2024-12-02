//
//  BannerUICollectionViewCell.swift
//  CustomControls
//
//  Created by Mohit Dubey on 20/09/24.
//

import UIKit

class BannerUICollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var bannerTitle: UILabel!
    @IBOutlet weak var imageCenterConstraint: NSLayoutConstraint!
    
    var parallexEffect: CGFloat = 0 {
        didSet {
            imageCenterConstraint.constant = parallexEffect
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bannerImage.contentMode = .scaleAspectFill
    }

    func setupImage(named imageName: String) {
        bannerImage.image = nil
        bannerImage.image = UIImage(named: imageName)
    }
}
