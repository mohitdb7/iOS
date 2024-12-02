//
//  WebViewNavBarView.swift
//  CustomControlsBootcampUIKIT
//
//  Created by mohit.dubey on 22/06/23.
//

import UIKit

protocol WebNavbarActions: AnyObject {
    func takeSnapshot()
    func reloadWebPage()
    func navigateBack()
    func navigateForward()
}

class WebViewNavBarView: UIView {
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var reloadPage: UIImageView!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var snapshotPage: UIImageView!
    
    weak var delegate: WebNavbarActions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let snapShotTapGesture = UITapGestureRecognizer(target: self, action: #selector(snapshotTapped))
        snapshotPage.isUserInteractionEnabled = true
        snapshotPage.addGestureRecognizer(snapShotTapGesture)
        
        let reloadTapGesture = UITapGestureRecognizer(target: self, action: #selector(reloadTapped))
        reloadPage.isUserInteractionEnabled = true
        reloadPage.addGestureRecognizer(reloadTapGesture)
    }
    
    func update(currentPageNavigationTitle currentPage: String) {
        currentPageLabel.text = currentPage
    }
    
    @objc func snapshotTapped(_ sender: UITapGestureRecognizer) {
        print("Did tap on image \(sender)")
        delegate?.takeSnapshot()
    }
    
    @objc func reloadTapped(_ sender: UITapGestureRecognizer) {
        print("Did tap on image \(sender)")
        delegate?.reloadWebPage()
    }
}
