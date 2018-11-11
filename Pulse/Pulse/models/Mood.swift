//
//  Mood.swift
//  Pulse
//
//  Created by Reilly Freret on 11/10/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import Firebase

class Mood {
    
    var id: String!
    var value: Int!
    var dateTime: Date!
    
    init(_ id: String, _ v: Int, _ d: Date) {
        self.id = id
        self.value = v
        self.dateTime = d
    }
    
}
