//
//  Timer.swift
//  LocalNotificationDemo
//
//  Created by TinhPV on 2/14/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import Foundation
import UserNotifications

class TimerModel: NSObject {
    
    static let sharedTimer: TimerModel = {
        let timer = TimerModel()
        return timer
    }()
    
    var internalTimer: Timer?
    var jobs = [() -> Void]()
    var counter: TimeInterval = 0
    
    func startTimer(withInterval interval: Double, counter: TimeInterval, andJob job: @escaping () -> Void) {
        if internalTimer != nil {
            internalTimer?.invalidate()
            internalTimer = nil
        }
        
        self.counter = counter
        jobs.append(job)
        internalTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(doJob), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        internalTimer?.invalidate()
    }
    
    func stopTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        jobs = [()->()]()
        internalTimer?.invalidate()
    }
    
        func createNotification() {
    
            let mathContent = UNMutableNotificationContent()
            mathContent.title = "Demo"
            mathContent.subtitle = "justDemo"
            mathContent.body = "Time's up"
            mathContent.badge = 1
    
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    
            let quizRequestID = "mathQuiz"
            let request = UNNotificationRequest(identifier: quizRequestID, content: mathContent, trigger: trigger)
    
            UNUserNotificationCenter.current().add(request) { (error) in
                
            }
        }
    
    @objc func doJob() {
        for job in jobs {
            counter -= 1
            if counter == 0 {
                createNotification()
            }
            job()
        }
    }
    
}
