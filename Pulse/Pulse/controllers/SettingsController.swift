//
//  SettingsController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/13/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class SettingsController: UIViewController {
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.view.screenLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                User.removeAllData()
                self.view.screenLoaded()
                let v = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loggedOut"))
                v.setNavigationBarHidden(true, animated: false)
                UIView.transition(with: ((UIApplication.shared.delegate?.window)!)!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    ((UIApplication.shared.delegate?.window)!)!.rootViewController = v
                }, completion: nil)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
