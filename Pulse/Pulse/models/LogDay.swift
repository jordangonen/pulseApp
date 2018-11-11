//
//  LogDay.swift
//  Pulse
//
//  Created by Reilly Freret on 11/11/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

class LogDay {
    
    var moods: [Mood] = [Mood]()
    var weather: Weather?
    var steps: Int?
    var avg: Float {
        var avg = Float(0)
        let _ = moods.map { avg += Float($0.value) }
        return moods.count == 0 ? 0 : Float(Int((100 * avg / Float(moods.count)) / 100))
    }
    
    func color() -> UIColor {
        if moods.count == 0 { return UIColor.lightGray }
        
        // converts the average mood into a transparency value between 0.5 and 1.0
        let affa = CGFloat(Double(Int(avg * 100 - 1) % 100) / 100.0) / 2.0 + 0.5
        
        switch avg {
        case 0..<1:
            return UIColor.Pulse.red.withAlphaComponent(1.5 - affa)
            break
        case 1..<2:
            return UIColor.Pulse.yellow.withAlphaComponent(affa)
            break
        case 2...4:
            return UIColor.Pulse.green.withAlphaComponent(affa)
            break
        default:
            return UIColor.black
        }
    }
    
}
