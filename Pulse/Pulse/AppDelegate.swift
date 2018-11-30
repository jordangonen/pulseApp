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

let db = Firestore.firestore()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        // debugging (true = force login, false = normal operation)
        if false {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        //
        
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

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

