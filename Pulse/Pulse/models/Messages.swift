//
//  Messages.swift
//  Pulse
//
//  Created by Reilly Freret on 11/9/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation

class WelcomeMessage {
    
    static func getMessage() -> String {
        //time stuff
        var tod = String()
        switch Calendar.current.component(.hour, from: Date()) {
        case 4..<12:
            tod = "morning"
            break
        case 12..<18:
            tod = "afternoon"
            break
        default:
            tod = "evening"
            break
        }
        
        // return actual
        let m = User.firstName != nil ? ", " + User.firstName! : ""
        return "Good \(tod)\(m). How are you feeling?"
    }
}
