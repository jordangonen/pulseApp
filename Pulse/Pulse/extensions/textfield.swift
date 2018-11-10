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
    
    func validateName() -> Bool {
        return self.formatBorder(self.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "")
    }
    
    func validateEmail() -> Bool {
        guard let input = self.text else { return false }
        return self.formatBorder((input.matches("[\\S]+@[\\S]+\\.[\\S]")))
    }
    
    func validatePassword() -> Bool {
        guard let input = self.text else { return false }
        return self.formatBorder(input.count > 7)
    }
    
    func formatBorder(_ good: Bool) -> Bool {
        self.layer.borderColor = good ? UIColor.Pulse.green.cgColor : UIColor.Pulse.red.cgColor
        return good
    }
    
}
