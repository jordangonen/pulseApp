//
//  LoggedInController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/9/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoggedInController: UIViewController {
    
    @IBOutlet var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateLocalUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.populateLocalUser()
    }
    
    func populateLocalUser() {
        if User.firstName == nil {
            self.view.screenLoading()
            User.getNamesFromID((Auth.auth().currentUser?.uid)!) { success in
                if success {
                    self.greetingLabel.text = WelcomeMessage.getMessage()
                    self.view.screenLoaded()
                } else {
                    self.view.screenLoaded()
                    let p = UIStoryboard(name: "OnboardingTest", bundle: nil).instantiateViewController(withIdentifier: "profile")
                    p.modalTransitionStyle = .coverVertical
                    self.present(p, animated: true, completion: nil)
                }
            }
        } else {
            greetingLabel.text = WelcomeMessage.getMessage()
        }
    }
}
