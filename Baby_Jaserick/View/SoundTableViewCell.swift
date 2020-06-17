//
//  SoundTableViewCell.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/25/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class SoundTableViewCell: UITableViewCell {

    @IBOutlet weak var soundName: UILabel!
    @IBOutlet weak var selectedStatus: UIImageView!
    
    var isSelectedSound: Bool = false {
        didSet {
            if !isSelectedSound {
                selectedStatus.isHidden = true
            } else {
                selectedStatus.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedStatus.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
