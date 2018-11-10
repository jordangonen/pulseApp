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
        
        // return actual
        let m = User.firstName != nil ? ", " + User.firstName! : ""
        return "Good morning\(m). How are you feeling today?"
    }
}
