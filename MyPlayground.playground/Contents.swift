import UIKit
import Foundation

let tod = Date()
var dc = DateComponents()
let currCal = Calendar.current
dc.year = currCal.component(.year, from: tod)
dc.month = currCal.component(.month, from: tod)
currCal.component(.weekday, from: currCal.date(from: dc)!)
currCal.range(of: .day, in: .month, for: tod)?.count
