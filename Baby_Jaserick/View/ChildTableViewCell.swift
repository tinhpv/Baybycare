//
//  ChildTableViewCell.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/26/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class ChildTableViewCell: UITableViewCell {
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var childContainer: UIView!
    
    @IBOutlet weak var shadowViewCell: UIView!
    
    var viewControllerOfCell: UIViewController? = nil
    
    var child: Child? {
        didSet {
            
            childName.text = child?.name
            if child?.imageURL != nil {
                let image = DataManager.sharedInstance.getImageFromDocumentDirectory(imageName: "\((child?.id)!)", type: .image)
                childImageView.image = image
                childImageView.layer.cornerRadius = childImageView.frame.height / 2
            }
        } // end didSet
    }
    
    var isSelectedChild: Bool = false {
        didSet {
            if isSelectedChild {
                statusButton.isSelected = true
            } else {
                statusButton.isSelected = false
            }
        } // end didSet
    }
    
    
    override func layoutSubviews() {
        
        if child?.imageURL == nil {
            childImageView.image = UIImage(named: "avatar")
        }
    
        statusButton.setImage(UIImage(named: "child_selected"), for: .selected)
        statusButton.setImage(UIImage(named: "child_uncheck"), for: .normal)
        
        childContainer.layer.cornerRadius = 10
        shadowViewCell.addShadow()
        shadowViewCell.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func statusButtonTapped(_ sender: Any) {
        
        if self.viewControllerOfCell is NewRouteViewController {
            let vc = self.viewControllerOfCell as! NewRouteViewController
            if isSelectedChild {
                let list = vc.selectedChildList.filter() { $0 != child }
                vc.selectedChildList = list
            } else {
                vc.selectedChildList.append(child!)
            } // end if bool
            
            if let route = vc.mainRoute {
                DBManager.sharedInstance.updateRouteList(listOfChildForUpdating: vc.selectedChildList, with: route.routeID)
            } 
            
        } // end if
        
        self.isSelectedChild = !self.isSelectedChild
        
    } // end method
    
}
