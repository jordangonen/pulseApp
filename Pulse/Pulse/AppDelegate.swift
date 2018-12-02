//
//  AppDelegate.swift
//  Pulse
//
//  Created by Reilly Freret on 11/8/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import UserNotificationsUI

let db = Firestore.firestore()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    var monthData = [Int: LogDay]()
    var currDate = Date()
    var currCal = Calendar.current
    var numDaysInMonth: Int {
        return (currCal.range(of: .day, in: .month, for: currDate)?.count)!
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        // debugging (true = force login, false = normal operation)
//        if false {
//            do {
//                try Auth.auth().signOut()
//            } catch let signOutError as NSError {
//                print ("Error signing out: %@", signOutError)
//            }
//        }
        //
        
        if Auth.auth().currentUser != nil {
            let v = UINavigationController(rootViewController: UIStoryboard(name: "LoggedIn", bundle: nil).instantiateViewController(withIdentifier: "loggedIn"))
            v.setNavigationBarHidden(true, animated: false)
            UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.window?.rootViewController = v
            }, completion: nil)
        }
        //Local Notifications
        print("beginning of notification code")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authorized:Bool, error:Error?) in
            if !authorized {
                print("app is useless because you did noow allow notifications")
            }
        }
        
        //Notification Actions
        
        //1 Define Action
        let sadAction = UNNotificationAction(identifier: "addSad", title: "I'm Feeling Sad", options: [])
        let mehAction = UNNotificationAction(identifier: "addMeh", title: "I'm Feeling Meh", options: [])
        let happyAction = UNNotificationAction(identifier: "addHappy", title: "I'm Feeling Happy", options:[])
        
        //2 Add actions
        let category = UNNotificationCategory(identifier: "addEmotion", actions: [sadAction, mehAction, happyAction], intentIdentifiers: [], options: [])
        
        //3 Add mood to notification framework
        UNUserNotificationCenter.current().setNotificationCategories([category])
        return true
    }
    func scheduleNotification(){
        
        UNUserNotificationCenter.current().delegate = self
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "How are you feeling?"
        content.body = "Just a reminder to log your mood."
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "addEmotion"
        
        guard let path = Bundle.main.path(forResource: "emotions", ofType: "png") else {return print("cant find image")}
        let url = URL(fileURLWithPath: path)
        //print("URL Path \(url)")
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachment]
        }catch{
            print("Attachment could not load")
        }
        
        let request = UNNotificationRequest(identifier: "moodNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error:Error?) in
            if let error = error {
                print("error \(error.localizedDescription)")
            }
        }
        print("reached  end of scheduleNotifdication")
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //create mood item
        let m = Mood(0, Date(), "63130")
        
        if response.actionIdentifier == "addSad"{
            print("clicked sad")
            m.value = 0
        }else if response.actionIdentifier == "addMeh"{
            print("clicked meh")
            m.value = 1
        }else{
            print("clicked happy")
            m.value = 2
        }
        m.upload({ b in
            if !b {
                // TODO: alert upload error
            }
        }, { b in
            if b {
                let dayInt = self.currCal.component(.day, from: self.currDate)
                if let d = self.monthData[dayInt] {
                    d.moods.append(m)
                } else {
                    let d = LogDay()
                    d.moods.append(m)
                    self.monthData[dayInt] = d
                }
            } else {
                // TODO: alert update error
            }
        })
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "key"), object: nil)
        completionHandler()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("entered foreground")
        if Auth.auth().currentUser != nil {
            print("entered foreground if")
            
            let v = UINavigationController(rootViewController: UIStoryboard(name: "LoggedIn", bundle: nil).instantiateViewController(withIdentifier: "loggedIn"))
            v.setNavigationBarHidden(true, animated: false)
            UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.window?.rootViewController = v
            }, completion: nil)
        }
        NotificationCenter.default.removeObserver(self)
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("closed app")
        scheduleNotification()
        
    }



    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

