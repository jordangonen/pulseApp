//
//  OnboardingController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/8/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

class OnboardingController: UIViewController {
    
    var slides = [OnboardingSlide]()
    
    @IBOutlet var obScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slides = loadSlides()
        setupScrollView()
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func setupScrollView() {
        obScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        obScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            obScrollView.addSubview(slides[i])
        }
    }
    
    func loadSlides() -> [OnboardingSlide] {
        let slide0 = Bundle.main.loadNibNamed("OnboardingPage", owner: self, options: nil)?.first as! OnboardingSlide
        slide0.image.image = UIImage(named: "celly")
        slide0.title.text = "Welcome to Pulse"
        slide0.subtitle.text = "Pulse helps you track your mood and better understand your feelings"
        
        let slide1 = Bundle.main.loadNibNamed("OnboardingPage", owner: self, options: nil)?.first as! OnboardingSlide
        slide1.image.image = UIImage(named: "selection")
        slide1.title.text = "Enable Notifications"
        slide1.subtitle.text = "We send you periodic push notifications so you can record how you're feeling"
        
        let slide2 = Bundle.main.loadNibNamed("OnboardingPage", owner: self, options: nil)?.first as! OnboardingSlide
        slide2.image.image = UIImage(named: "balloons")
        slide2.title.text = "Track Your Mood"
        slide2.subtitle.text = "You're all set! Click \"Finish\" to begin your journey into the quantified self"
        
        return [slide0, slide1, slide2]
    }
    
}
