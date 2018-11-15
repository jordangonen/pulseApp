//
//  WeatherDay.swift
//  Pulse
//
//  Created by Reilly Freret on 11/11/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

class Weather: Codable {
    
    var lowTemp: Int!
    var highTemp: Int!
    var type: String!
    var imageString: String?
    
    init(l: Int, h: Int, t: String) {
        self.lowTemp = l
        self.highTemp = h
        self.type = t
    }
}
