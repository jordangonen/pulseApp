//
//  AppDelegate.swift
//  Pulse
//
//  Created by Team Pulse.
//  Copyright © 2018 Pulse Team. All rights reserved.
// Notification tutorial: https://www.youtube.com/watch?v=e7cTZ4Tp25I


import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import UserNotificationsUI

let db = Firestore.firestore()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    //Month information needed for mood uploading
    var monthData = [Int: LogDay]()
    var currDate = Date()
    var currCal = Calendar.current
    var numDaysInMonth: Int {
        return (currCal.range(of: .day, in: .month, for: currDate)?.count)!
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        //if logged in then push to loggedInController
        if Auth.auth().currentUser != nil {
            let v = UINavigationController(rootViewController: UIStoryboard(name: "LoggedIn", bundle: nil).instantiateViewController(withIdentifier: "loggedIn"))
            v.setNavigationBarHidden(true, animated: false)
            UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.window?.rootViewController = v
            }, completion: nil)
        }
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    //Runs when you close the app
    func applicationDidEnterBackground(_ application: UIApplication) {

    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

