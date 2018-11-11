import UIKit
import Foundation

let tod = Date()
print(tod)
Calendar.current.component(.hour, from: tod)
