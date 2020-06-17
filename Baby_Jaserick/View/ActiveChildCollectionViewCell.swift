//
//  ActiveChildCollectionViewCell.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/30/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class ActiveChildCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var childName: UILabel!
    
    // MARK: - main variables
    var activeChild: Child? {
        didSet {
            childName.text = activeChild?.name
            if activeChild?.imageURL != nil {
                let image = DataManager.sharedInstance.getImageFromDocumentDirectory(imageName: "\((activeChild?.id)!)", type: .image)
                
                childImageView.layer.cornerRadius = childImageView.frame.height / 2
                childImageView.image = image
            } else {
                childImageView.image = UIImage(named: "avatar")
            }
        }
    }
    
}
