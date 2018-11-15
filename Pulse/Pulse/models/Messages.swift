//
//  Messages.swift
//  Pulse
//
//  Created by Reilly Freret on 11/9/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import Firebase

class Messages {
    
    static func getWelcome() -> String {
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
    
    static func getLastLog(_ completion: @escaping (String) -> Void) {
        var m = "N/a"
        guard let uid = Auth.auth().currentUser?.uid else { completion("error"); return }
        if User.lastLog == nil {
            db.document("users/\(uid)/stats/times").getDocument() { (document, error) in
                if let document = document, document.exists {
                    guard let d = document.data() else { return }
                    if let timeInt = d["lastLogTime"] as? Int {
                        if timeInt < 2 { m = "No logs yet" }
                        let date = Date(timeIntervalSince1970: TimeInterval(Double(timeInt)))
                        User.lastLog = date
                        m = date.englishDateDiffToNow()
                    } else if let timeInt = d["lastLogTime"] as? Double {
                        if timeInt < 2 { m = "No logs yet" }
                        let date = Date(timeIntervalSince1970: TimeInterval(timeInt))
                        User.lastLog = date
                        m = date.englishDateDiffToNow()
                    }
                    // FUCKTHIS.exe
                    completion(m)
                    return
                } else {
                    print("asdfasdf")
                }
            }
        } else if User.lastLog?.timeIntervalSince1970 == 0 {
            completion("No logs yet")
        } else {
            guard let d = User.lastLog else { completion("Failed"); return }
            completion(d.englishDateDiffToNow())
        }
    }
    
}
