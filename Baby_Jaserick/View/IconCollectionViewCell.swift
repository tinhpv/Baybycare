//
//  IconCollectionViewCell.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/24/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
        }
    }
    
}
