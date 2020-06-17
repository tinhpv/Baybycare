//
//  AppDelegate.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/24/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Init DB
        
        DBManager.sharedInstance.deleteAllDatabase()
        if DBManager.sharedInstance.getAllRoutes().count == 0 {
            let child = Child()
            child.name = "Child's Name"

            DBManager.sharedInstance.addChild(object: child)

            let route1 = Route()
            route1.routeName = "Work"
            route1.pickerWay = "quicktime"
            route1.minute = "\(5)"
            route1.isActive = false
            route1.childList.append(child)

            let route2 = Route()
            route2.routeName = "Home"
            route2.pickerWay = "quicktime"
            route2.minute = "\(5)"
            route2.isActive = false
            route2.childList.append(child)

            DBManager.sharedInstance.addRoute(object: route1)
            DBManager.sharedInstance.addRoute(object: route2)
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print(error as Any)
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = #colorLiteral(red: 0.9843137255, green: 0.8235294118, blue: 0.2470588235, alpha: 1)
        navigationBarAppearace.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Futura", size: 20)!]
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Futura", size: 18)!], for: .normal)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if TimerModel.sharedTimer.internalTimer != nil {
            let defaults = UserDefaults.standard
            defaults.setValue(Date(), forKey: Constant.KeyProgram.endTime)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let defaults = UserDefaults.standard
        if let date = defaults.value(forKey: Constant.KeyProgram.endTime) as? Date {
            TimerModel.sharedTimer.counter += date.timeIntervalSinceNow
        }
        defaults.setValue(nil, forKey: Constant.KeyProgram.endTime)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
}
