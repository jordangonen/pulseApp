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
    @IBAction func resetPassword(_ sender: Any) {
        
        var user = Auth.auth().currentUser;
        var name: String;
        var email: String;
        email = (user?.email)!;
        var name2: String;

        

        let alert = UIAlertController(title: "Password Reset", message: "Check your email. A password reset link will be sent.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            Auth.auth().sendPasswordReset(withEmail: email);
            
            
            do {
                try Auth.auth().signOut()
                self.view.screenLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
            
            
            
            

            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    
    }

 
    @IBAction func deleteUser(_ sender: Any) {
        var user = Auth.auth().currentUser;
        var name: String;
        var email: String;
        email = (user?.email)!;

        
        
        let alert = UIAlertController(title: "Delete Account", message: "This account will be deleted", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
          //  Auth.auth().currentUser?.delete(completion: name);
            Auth.auth().sendPasswordReset(withEmail: email);

            
            
            do {
                try Auth.auth().signOut()
                self.view.screenLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
            
            
            
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
