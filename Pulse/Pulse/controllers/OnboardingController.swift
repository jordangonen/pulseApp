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
    
    @IBOutlet var prevOutlet: UIButton!
    @IBOutlet var nextOutlet: UIButton!
    
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
        slide3.subtitle.text = "That's pretty much it! Click \"finish\" to create your profile and get started"
        
        return [slide0, slide1, slide2, slide3]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(obScrollView.contentOffset.x/view.frame.width))
        updateButtons(i: pageIndex)
        pageControl.currentPage = pageIndex
        pageControl.currentPageIndicatorTintColor = colors[pageIndex]
        pageControl.pageIndicatorTintColor = colors[pageIndex].withAlphaComponent(0.3)
    }
    
    func updateButtons(i: Int) {
        prevOutlet.setTitleColor(colors[i], for: .normal)
        nextOutlet.setTitleColor(colors[i], for: .normal)
        prevOutlet.setTitle(i == 0 ? "" : "< prev", for: .normal)
        nextOutlet.setTitle(i == slides.count - 1 ? "finish >" : "next >", for: .normal)
    }
    
    @IBAction func prevAction(_ sender: Any) {
        let pageIndex = Int(floor(obScrollView.contentOffset.x/view.frame.width))
        if pageIndex > 0 {
            let newOffset = view.frame.width * CGFloat(pageIndex - 1)
            obScrollView.setContentOffset(CGPoint(x: newOffset, y: -20), animated: true)
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if nextOutlet.title(for: .normal) == "finish >" {
            let c = UIStoryboard(name: "OnboardingTest", bundle: nil).instantiateViewController(withIdentifier: "profile")
            navigationController?.pushViewController(c, animated: true)
        }
        let pageIndex = Int(ceil(obScrollView.contentOffset.x/view.frame.width))
        if pageIndex < slides.count - 1 {
            let newOffset = view.frame.width * CGFloat(pageIndex + 1)
            obScrollView.setContentOffset(CGPoint(x: newOffset, y: -20), animated: true)
        }
    }
}
