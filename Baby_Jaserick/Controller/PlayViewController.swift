//
//  PlayViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/30/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    // MARK: -  iboutlet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeContainer: UIView!
    @IBOutlet weak var middleContainerView: UIView!
    @IBOutlet weak var activeRouteName: UILabel!
    @IBOutlet weak var playAndPauseButton: UIButton!
    @IBOutlet weak var activeChildCollectionView: UICollectionView!
    
    
    // MARK: - something for timing-calculation
    var isTimerRunning = false
    var playAgain = false
    var counter: TimeInterval = 0
    var trackCounter: TimeInterval = 0
    var endDate: Date?
    
    var minute: Int = 0
    var hour: Int = 0
    var second: Int = 0
    
    // MARK: - something for showing timing animation
    let shapeLayer = CAShapeLayer()
    var pulsatingLayer: CAShapeLayer!
    
    
    // MARK: - something belongs to viewcontroller
    var currentRoute: Route?
    
    // START.....................
    
    override func viewDidLayoutSubviews() {
        self.activeRouteName.text = currentRoute?.routeName
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initDataForTimer()
        createCircularProgress()
    }
    
    // MARK: - custom function
    
    func initDataForTimer() {

        trackCounter = 0
        
        if let hourString = currentRoute?.hour, let hour = Int(hourString) {
            trackCounter += TimeInterval(hour * 3600)
        }
        
        if let minuteString = currentRoute?.minute, let minute = Int(minuteString) {
            trackCounter += TimeInterval(minute * 60)
        }
        
        let timer = TimerModel.sharedTimer
        
        if playAgain {
            timer.counter = trackCounter
            isTimerRunning = false
            TimerModel.sharedTimer.createNotification(timeInterval: timer.counter)
            playAndPauseButton.isSelected = !playAndPauseButton.isSelected
            self.updatePlayButtonStatus()
        } else {
            
            if !(currentRoute?.isActive)! {
                timer.counter = trackCounter
                updateActiveRoute() // the isActive property now is updated to TRUE
                TimerModel.sharedTimer.createNotification(timeInterval: timer.counter)
            }
            
            startTimer()
            self.updatePlayButtonStatus()
           
        }
        
        let flooredCounter = Int(floor(TimerModel.sharedTimer.counter))
        hour = flooredCounter / 3600
        minute = (flooredCounter % 3600) / 60
        second = (flooredCounter % 3600) % 60
        updateLabel()
        
    } // end method
    
    func startTimer() {
        TimerModel.sharedTimer.startTimer(withInterval: 1.0, andJob: timerTick)
        endDate = Date().addingTimeInterval(counter)
        isTimerRunning = true
    }
    
    
    func createCircularProgress() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.3274293664)
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.black.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = CGPoint(x: middleContainerView.frame.size.width / 2, y:                       middleContainerView.frame.size.height / 2)
        
        middleContainerView.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = CGPoint(x: middleContainerView.frame.size.width / 2, y:                       middleContainerView.frame.size.height / 2)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        
        middleContainerView.layer.addSublayer(shapeLayer)
        
        if (currentRoute?.isActive)! {
            let percentage = CGFloat(trackCounter - TimerModel.sharedTimer.counter) / CGFloat(trackCounter)
            shapeLayer.strokeEnd = percentage
        }
        
        middleContainerView.bringSubviewToFront(timeContainer)
    }
    
    
    
    func updateLabel() {
        
        var hourString = "\(hour)"
        if hour < 10 {
            hourString = "0\(hour)"
        }
        
        var minuteString = "\(minute)"
        if minute < 10 {
            minuteString = "0\(minute)"
        }
        
        var secondString = "\(second)"
        if second < 10 {
            secondString = "0\(second)"
        }
        
        
        timeLabel.text = "\(hourString):\(minuteString):\(secondString)"
    }
    
    @objc func timerTick() {
        
        let timer = TimerModel.sharedTimer
        print(timer.counter)
        if timer.counter == 0 {
            playAgain = true
        }
        
        let percentage = CGFloat(trackCounter - timer.counter) / CGFloat(trackCounter)
        self.shapeLayer.strokeEnd = percentage
        
        let flooredCounter = Int(floor(timer.counter))
        hour = flooredCounter / 3600
        minute = (flooredCounter % 3600) / 60
        second = (flooredCounter % 3600) % 60
        
        self.updateLabel()
    }
    
    func updateActiveRoute() {
        // update the status of current route
        let updatingRoute = Route()
        updatingRoute.routeID = (currentRoute?.routeID)!
        updatingRoute.routeName = (currentRoute?.routeName)!
        updatingRoute.icon = (currentRoute?.icon) ?? nil
        updatingRoute.hour = (currentRoute?.hour) ?? nil
        updatingRoute.minute = (currentRoute?.minute) ?? nil
        updatingRoute.pickerWay = (currentRoute?.pickerWay) ?? nil
        updatingRoute.childList = (currentRoute?.childList)!
        
        updatingRoute.isActive = true
        DBManager.sharedInstance.updateRoute(with: (currentRoute?.routeID)!, newRouteForUpdate: updatingRoute)
    }
    
    func handleEdit(alert: UIAlertAction!) {
        // save the time
        updateActiveRoute()
        let defaults = UserDefaults.standard
        defaults.setValue(endDate, forKey: Constant.KeyProgram.endTime)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleCancel(alert: UIAlertAction!) {
        // update the status of current route
        let updatingRoute = Route()
        updatingRoute.routeID = (currentRoute?.routeID)!
        updatingRoute.routeName = (currentRoute?.routeName)!
        updatingRoute.icon = (currentRoute?.icon) ?? nil
        updatingRoute.hour = (currentRoute?.hour) ?? nil
        updatingRoute.minute = (currentRoute?.minute) ?? nil
        updatingRoute.pickerWay = (currentRoute?.pickerWay) ?? nil
        updatingRoute.childList = (currentRoute?.childList)!
        updatingRoute.isActive = false
        DBManager.sharedInstance.updateRoute(with: (currentRoute?.routeID)!, newRouteForUpdate: updatingRoute)
        let currentActiveRouteSave = UserDefaults.standard
        currentActiveRouteSave.setValue(nil, forKey: Constant.KeyProgram.activeRouteID)
        TimerModel.sharedTimer.stopTimer()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String, status: String) {
        let alert = UIAlertController(title: "Please...", message: message, preferredStyle: .alert)
        
        let allowAction: UIAlertAction?
        
        if status == "Edit" {
            allowAction = UIAlertAction(title: "OK", style: .default, handler: self.handleEdit)
        } else {
            allowAction = UIAlertAction(title: "OK", style: .default, handler: self.handleCancel)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(allowAction!)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    
    func updatePlayButtonStatus() {
        
        if isTimerRunning {
            if let image = UIImage(named: "pause") {
                playAndPauseButton.setImage(image, for: .normal)
            } // end video
        } else {
            if let image = UIImage(named: "play") {
                playAndPauseButton.setImage(image, for: .selected)
            }
        }
    }
    
    
    // MARK: -  ibaction
    
    @IBAction func playAndPauseButtonTapped(_ sender: UIButton) {
        
        playAndPauseButton.isSelected = !playAndPauseButton.isSelected
    
        if isTimerRunning {
            TimerModel.sharedTimer.pauseTimer()
            isTimerRunning = false
        } else {
            TimerModel.sharedTimer.startTimer(withInterval: 1.0, andJob: {
                self.timerTick()
            })
            isTimerRunning = true
        }
        
        updatePlayButtonStatus()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.showAlert(message: "Do you want to edit an active route?", status: "Edit")
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.showAlert(message: "Do you want to stop this route?", status: "Cancel")
    }
}


extension PlayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.currentRoute?.childList.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = activeChildCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.activeChildCell, for: indexPath) as! ActiveChildCollectionViewCell
        cell.activeChild = self.currentRoute?.childList[indexPath.row]
        return cell
    }
    
}
