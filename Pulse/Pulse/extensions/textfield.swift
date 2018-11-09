//
//  textfield.swift
//  Pulse
//
//  Created by Reilly Freret on 11/8/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func validateEmail() -> Bool {
        guard let input = self.text else { return false }
        if (input.matches("[\\S]+@[\\S]+\\.[\\S]")) {
            self.layer.borderColor = UIColor.green.cgColor
            return true
        } else {
            self.layer.borderColor = UIColor.red.cgColor
            return false
        }
    }
    
    func validatePassword() -> Bool {
        guard let input = self.text else { return false }
        if (input.count > 7) {
            self.layer.borderColor = UIColor.green.cgColor
            return true
        } else {
            self.layer.borderColor = UIColor.red.cgColor
            return false
        }
    }
}
