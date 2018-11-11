//
//  User.swift
//  Pulse
//
//  Created by Reilly Freret on 11/9/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    static var firstName: String?
    static var lastName: String?
    static var lastLog: Date?
    
    static func getNamesFromID(_ id: String, _ completion: @escaping (Bool) -> Void) {
        db.collection("users").document(id).getDocument() { (document, error) in
            if let document = document, document.exists {
                guard let d = document.data() else { return }
                self.firstName = d["firstName"] as? String
                self.lastName = d["lastName"] as? String
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
