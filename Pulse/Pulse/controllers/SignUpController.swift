//
//  SignUpController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/8/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class SignUpController: UIViewController {
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var emailOutlet: UITextField!
    
    @IBOutlet var passwordOutlet: UITextField!
    
    @IBOutlet var confirmOutlet: UITextField!
    
    
    @IBAction func emailDidChange(_ sender: Any) {
        let _ = emailOutlet.validateEmail()
    }
    
    
    @IBAction func passwordDidChange(_ sender: Any) {
        let _ = passwordOutlet.validatePassword()
    }
    
    
    @IBAction func confirmChanged(_ sender: Any) {
        let _ = confirmOutlet.validatePassword()
    }
    
    @IBAction func confirmWithReturn(_ sender: Any) {
        submitSignup(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // debugging
        let hah = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboardingJawn")
        self.navigationController?.pushViewController(hah, animated: true)
        // end debugging
        emailOutlet.layer.borderWidth = 1.0
        passwordOutlet.layer.borderWidth = 1.0
        confirmOutlet.layer.borderWidth = 1.0
    }
    
    
    @IBAction func submitSignup(_ sender: Any) {
        if validateAll() {
            self.view.screenLoading()
            Auth.auth().createUser(withEmail: (emailOutlet.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))!, password: passwordOutlet.text!) { (authResult, error) in
                print("\nresult: \(String(describing: authResult))")
                print("\nerror:\(String(describing: error))")
                self.view.screenLoaded()
                let hah = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboardingJawn")
                self.navigationController?.pushViewController(hah, animated: true)
            }
        }
    }
    
    func validatePassMatch() -> Bool {
        return passwordOutlet.text == confirmOutlet.text
    }
    
    func validateAll() -> Bool {
        return emailOutlet.validateEmail() && passwordOutlet.validatePassword() && confirmOutlet.validatePassword()  && validatePassMatch()
    }
}
