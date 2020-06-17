//
//  RouteTableViewCell.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/24/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var containerCell: UIView!
    @IBOutlet weak var shadowContainerCell: UIView!
    
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var minuteString = "00"
    var hourString = "00"
    var secondString = "00"
    
    var route: Route? {
        didSet {
            
            // children's name
            var childNameList = ""
            for child in (route?.childList)! {
                childNameList += child.name + ", "
            }
            childName.text = String(childNameList.dropLast(2))
            
            // route's name
            routeName.text = route?.routeName
            
            // route's icon
            if route?.icon != nil {
                iconImageView.isHidden = false
                iconImageView.image = DataManager.sharedInstance.getImageFromDocumentDirectory(imageName: (route?.routeID)!, type: .icon)
            } else {
                iconImageView.isHidden = true
            }
            
            // route's status
            if (route?.isActive)! {
                status.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.5647058824, blue: 0.2823529412, alpha: 1)
                routeName.textColor = #colorLiteral(red: 0.09411764706, green: 0.5647058824, blue: 0.2823529412, alpha: 1)
                timeStart()
            } else {
                status.backgroundColor = UIColor.clear
                routeName.textColor = UIColor.black
                
                var min = ""
                var hour = "00"
                
                if route?.minute != nil {
                    if Int((route?.minute)!)! < 10 {
                        min = "0\((route?.minute)!)"
                    } else {
                        min = "\((route?.minute)!)"
                    }
                }
                
                
                
                if route?.hour != nil {
                    if Int((route?.hour)!)! < 10 {
                        hour = "0\((route?.hour)!)"
                    }
                }
                
                self.timeLeftLabel.text = "\(hour):\(min) min"
            }
            
        } // end didSet
    }
    
    override func layoutSubviews() {
        self.containerCell.roundCorners(corners: [.topLeft, .bottomLeft], radius: 26)
        self.shadowContainerCell.addShadow()
        self.shadowContainerCell.layer.cornerRadius = 26
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateLabel() {
        timeLeftLabel.text = "\(hourString):\(minuteString):\(secondString)"
    }
    
    @objc func timerTick() {
        let timer = TimerModel.sharedTimer
        
        let flooredCounter = Int(floor(timer.counter))
        let hour = flooredCounter / 3600
        hourString = "\(hour)"
        if hour < 10 {
            hourString = "0\(hour)"
        }
        
        let minute = (flooredCounter % 3600) / 60
        minuteString = "\(minute)"
        if minute < 10 {
            minuteString = "0\(minute)"
        }
        
        let second = (flooredCounter % 3600) % 60
        secondString = "\(second)"
        if second < 10 {
            secondString = "0\(second)"
        }
        
        self.updateLabel()
    }
    
    func timeStart() {
        TimerModel.sharedTimer.startTimer(withInterval: 1.0, andJob: timerTick)
    }
}
