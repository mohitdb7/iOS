//
//  BannerUICollection.swift
//  CustomControls
//
//  Created by Mohit Dubey on 20/09/24.
//

import UIKit
import math_h

class BannerUICollection: UICollectionView {
    
    let items = ["1", "2", "3", "4", "5", "6", "7"]
    let colors: [UIColor] = [.blue, .red, .green, .yellow, .orange, .cyan, .magenta, .brown]

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
        
        self.isPagingEnabled = true
        self.bounces = false
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = false
        
        let nib = UINib(nibName: "\(BannerUICollectionViewCell.self)", bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: "\(BannerUICollectionViewCell.self)")
        
        self.register(DummyCollectionViewCell.self, forCellWithReuseIdentifier: "\(DummyCollectionViewCell.self)")
    }
}

extension BannerUICollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.dequeueReusableCell(withReuseIdentifier: "\(BannerUICollectionViewCell.self)", for: indexPath) as? BannerUICollectionViewCell {
            
            cell.setupImage(named: items[indexPath.row])
            return cell
        } else if let cell = self.dequeueReusableCell(withReuseIdentifier: "\(DummyCollectionViewCell.self)", for: indexPath) as? DummyCollectionViewCell {
            cell.backgroundColor = colors[indexPath.row]
            return cell
        }
        
       
        return UICollectionViewCell()
    }
}


extension BannerUICollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        let height = self.bounds.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension BannerUICollection: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let denominator = abs(math_h.ceil(scrollView.contentOffset.x / 393))
        print(denominator, scrollView.contentOffset.x / (denominator * 393))
    }
}
