//
//  DetailItemView.swift
//  photosAppExample
//
//  Created by Mohit Dubey on 08/08/24.
//

import UIKit

class DetailItemView: UIView {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var image: UIImage!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

}
