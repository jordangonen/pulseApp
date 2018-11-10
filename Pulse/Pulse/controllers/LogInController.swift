//
//  LogInController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/8/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LogInController: UIViewController {
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet var emailOutlet: UITextField!
    
    @IBOutlet var passwordOutlet: UITextField!
    
    @IBAction func emailAction(_ sender: Any) {
        passwordOutlet.becomeFirstResponder()
    }
    
    @IBAction func passwordAction(_ sender: Any) {
        passwordOutlet.resignFirstResponder()
        loginButton(self)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        self.view.screenLoading()
        Auth.auth().signIn(withEmail: emailOutlet.text!, password: passwordOutlet.text!) { (authResult, error) in
            if authResult != nil {
                User.getNamesFromID((authResult?.user.uid)!) { _ in
                    self.view.screenLoaded()
                    let v = UINavigationController(rootViewController: UIStoryboard(name: "LoggedIn", bundle: nil).instantiateViewController(withIdentifier: "loggedIn"))
                    v.setNavigationBarHidden(true, animated: false)
                    UIView.transition(with: ((UIApplication.shared.delegate?.window)!)!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                        UIApplication.shared.delegate?.window!?.rootViewController = v
                    }, completion: nil)
                }
            } else if error != nil {
                self.view.screenLoaded()
                let alert = UIAlertController(title: "Uh-oh!", message: "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { UIAlertAction in self.loginButton(self) }))
                if let e = AuthErrorCode(rawValue: error!._code) {
                    switch e {
                    case .wrongPassword:
                        alert.message = "Login failed (password)"
                        break
                    case .invalidEmail:
                        alert.message = "That email address doesn't look quite right"
                        break
                    default:
                        break
                    }
                }
                self.present(alert, animated: true)
            }
            self.view.screenLoaded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailOutlet.layer.borderWidth = 1.0
        passwordOutlet.layer.borderWidth = 1.0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

    }
}
