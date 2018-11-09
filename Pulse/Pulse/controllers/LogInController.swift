//
//  LogInController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/8/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LogInController: UIViewController {
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet var emailOutlet: UITextField!
    
    @IBOutlet var passwordOutlet: UITextField!
    
    
    @IBAction func loginButton(_ sender: Any) {
        if !(emailOutlet.validateEmail() || passwordOutlet.validatePassword()) { return }
        self.view.screenLoading()
        Auth.auth().signIn(withEmail: emailOutlet.text!, password: passwordOutlet.text!) { (authResult, error) in
            print("\n\(String(describing: authResult?.user))")
            self.view.screenLoaded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailOutlet.layer.borderWidth = 1.0
        passwordOutlet.layer.borderWidth = 1.0
    }
}
