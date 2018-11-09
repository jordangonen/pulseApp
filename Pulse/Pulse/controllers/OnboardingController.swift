//
//  OnboardingController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/8/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

class OnboardingController: UIViewController, UIScrollViewDelegate {
    
    var slides = [OnboardingSlide]()
    let colors: [UIColor] = [UIColor.white, UIColor.Pulse.green, UIColor.Pulse.red, UIColor.Pulse.green]
    
    @IBOutlet var obScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        obScrollView.delegate = self
        slides = loadSlides()
        setupScrollView()
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func setupScrollView() {
        obScrollView.contentSize.width = view.frame.width * CGFloat(slides.count)
        obScrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: -20, width: view.frame.width, height: view.frame.height)
            obScrollView.addSubview(slides[i])
        }
    }
    
    func loadSlides() -> [OnboardingSlide] {
        let slide0 = Bundle.main.loadNibNamed("OnboardingPage", owner: self, options: nil)?.first as! OnboardingSlide
        slide0.image.image = UIImage(named: "newcelly")
        slide0.title.text = "Welcome to Pulse"
        slide0.subtitle.text = "Pulse helps you track your mood and better understand your feelings"
        slide0.title.textColor = UIColor.white
        slide0.subtitle.textColor = UIColor.white
        slide0.backgroundColor = UIColor.Pulse.green
        
        let slide1 = Bundle.main.loadNibNamed("OnboardingPage", owner: self, options: nil)?.first as! OnboardingSlide
        slide1.image.image = UIImage(named: "selection")
        slide1.title.text = "Enable Notifications"
        slide1.subtitle.text = "We send you periodic push notifications so you can record how you're feeling"
        
        let slide2 = Bundle.main.loadNibNamed("OnboardingPage", owner: self, options: nil)?.first as! OnboardingSlide
        slide2.image.image = UIImage(named: "health")
        slide2.title.text = "Enable HealthKit"
        slide2.subtitle.text = "Get insights into how your daily activity impacts your mood"
        
        let slide3 = Bundle.main.loadNibNamed("OnboardingPage", owner: self, options: nil)?.first as! OnboardingSlide
        slide3.image.image = UIImage(named: "balloons")
        slide3.title.text = "Track Your Mood"
        slide3.subtitle.text = "You're all set! Click \"Finish\" to begin your journey into the quantified self"
        
        return [slide0, slide1, slide2, slide3]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(obScrollView.contentOffset.x/view.frame.width))
        pageControl.currentPage = pageIndex
        pageControl.currentPageIndicatorTintColor = colors[pageIndex]
        pageControl.pageIndicatorTintColor = colors[pageIndex].withAlphaComponent(0.3)
    }
}
