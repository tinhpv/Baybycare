//
//  Drawing.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 2/14/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

struct Drawing {
    static func createCircularProgress() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.black.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = CGPoint(x: middleContainerView.frame.size.width / 2, y:                       middleContainerView.frame.size.height / 2)
        middleContainerView.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = CGPoint(x: middleContainerView.frame.size.width / 2, y:                       middleContainerView.frame.size.height / 2)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        middleContainerView.layer.addSublayer(shapeLayer)
        
        if !(currentRoute?.isActive)! {
            let percentage = CGFloat(trackCounter - counter) / CGFloat(trackCounter)
            shapeLayer.strokeEnd = percentage
        }
        
        middleContainerView.bringSubviewToFront(timeContainer)
    }
}
