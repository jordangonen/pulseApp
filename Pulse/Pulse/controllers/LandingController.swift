//
//  LandingController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/9/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

class LandingController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        print("\n\nAAAH\n\n")
        let grad = CAGradientLayer()
        grad.frame = self.view.bounds
        grad.startPoint = CGPoint(x: 0.0, y: 0.0)
        grad.endPoint = CGPoint(x: 1.0, y: 1.0)
        grad.colors = [UIColor.Pulse.green.cgColor, UIColor.Pulse.lightGreen.cgColor]
        self.view.layer.insertSublayer(grad, at: 0)
    }
}
