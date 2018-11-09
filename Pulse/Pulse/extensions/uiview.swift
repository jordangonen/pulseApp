//
//  uiview.swift
//  Pulse
//
//  Created by Reilly Freret on 11/8/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func screenLoading() {
        let loadingView = UIView(frame: self.frame)
        loadingView.tag = 69
        loadingView.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        let loadingAnimation = UIView()
        loadingAnimation.frame.size = CGSize(width: 100, height: 100)
        loadingAnimation.layer.cornerRadius = 50
        loadingAnimation.center = loadingView.center
        loadingAnimation.backgroundColor = UIColor.Pulse.green
        loadingView.addSubview(loadingAnimation)
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            loadingAnimation.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            loadingAnimation.backgroundColor = UIColor.Pulse.lightGreen
        })
        self.addSubview(loadingView)
    }
    
    func screenLoaded() {
        self.viewWithTag(69)?.removeFromSuperview()
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
