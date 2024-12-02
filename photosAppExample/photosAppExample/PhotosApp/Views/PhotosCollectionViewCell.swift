//
//  PhotosCollectionViewCell.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 05/08/24.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoImage.contentMode = .scaleAspectFill
    }

}
