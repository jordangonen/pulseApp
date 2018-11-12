//
//  User.swift
//  Pulse
//
//  Created by Reilly Freret on 11/9/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import Firebase

struct User: Codable {
    
    static var firstName: String?
    static var lastName: String?
    static var lastLog: Date?
    static var totalLogs: Int?
    static var id: String? {
        return Auth.auth().currentUser?.uid
    }
    
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
    
    static func totalLogs(_ completion: @escaping (Int) -> Void) {
        if let logs = self.totalLogs {
            completion(logs)
        } else {
            if let id: String = self.id {
                db.document("users/\(id)/stats/counts").getDocument() { (document, error) in
                    if let document = document, document.exists {
                        guard let d = document.data() else { completion(-2); return }
                        if let t = d["totalLogs"] as? Int {
                            self.totalLogs = t
                            completion(t)
                        } else {
                            completion(-3)
                            print("\nNo totallogs found")
                        }
                    } else {
                        completion(-1)
                        print("couldn't find documents somehow?")
                        print(error)
                    }
                }
            }
        }
    }
}
