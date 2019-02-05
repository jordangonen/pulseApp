//
//  LoggedInController.swift
//  Pulse
//
//  Created by Team Pulse on 11/9/18.
//  Copyright © 2018 Team Pulse. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class LoggedInController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, BlurDelegate  {
    
    
    
    // outlet variables
    @IBOutlet var dayHeadingStack: UIStackView!
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var sadButtonOutlet: UIButton!
    @IBOutlet var neutralButtonOutlet: UIButton!
    @IBOutlet var happyButtonOutlet: UIButton!
    @IBOutlet var emotionStackView: UIStackView!
    @IBOutlet var calendarJawn: UICollectionView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var totalLogs: UILabel!
    @IBOutlet var lastLogLabel: UILabel!
    @IBOutlet var prevMonthOutlet: UIButton!
    @IBOutlet var nextMonthOutlet: UIButton!
    @IBOutlet var checkLater: UILabel!
    
    // data management variables
    var monthData = [Int: LogDay]()
    var currDate = Date()
    var currCal = Calendar.current
    var numDaysInMonth: Int {
        return (currCal.range(of: .day, in: .month, for: currDate)?.count)!
    }
    
    // advances calendar by one month
    @IBAction func nextButton(_ sender: Any) {
        // adds one month to curr date
        currDate = currCal.date(byAdding: .month, value: +1, to: currDate)!
        reloadLabels()
        self.calendarJawn.reloadData()
        self.view.screenLoading()
        // fetch curr dates
        let month = currCal.component(.month, from: currDate)
        let year = currCal.component(.year, from: currDate)
        // fetch moods from newly designated month and fill month data
        User.moodsFromMonth(year, month) { s in
            guard let x: [Int: LogDay] = s else { return }
            self.monthData = x
            self.calendarJawn.reloadData()
            // run loading screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.view.screenLoaded()
            }
        }
    }
 
    // same as next date but for previous month
    @IBAction func prevButton(_ sender: Any) {
        currDate = currCal.date(byAdding: .month, value: -1, to: currDate)!
        reloadLabels()
        self.calendarJawn.reloadData()
        self.view.screenLoading()
        
        let month = currCal.component(.month, from: currDate)
        let year = currCal.component(.year, from: currDate)
        User.moodsFromMonth(year, month) { s in
            guard let x: [Int: LogDay] = s else { return }
            self.monthData = x
            self.calendarJawn.reloadData()
            // run loading screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.view.screenLoaded()
            }
        }
    }
    
    // holds weather api results
    var weatherResults: Weather? = nil
    
    // e.g. if the first of the month is a Thursday, startingWeekdayIndexed = 4
    var startingWeekdayIndexed: Int {
        var dc = DateComponents()
        dc.year = currCal.component(.year, from: currDate)
        dc.month = currCal.component(.month, from: currDate)
        return currCal.component(.weekday, from: currCal.date(from: dc)!) - 1
    }
    
    // to settings
    @IBAction func goSettings(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "settings"), animated: true)
    }
    
    // runs on view did load
    override func viewDidLoad() {
        // populate initial variables
        super.viewDidLoad()
        
        self.populateLocalUser()
        self.setupButtons()
        self.setupCellConstraints()
        calendarJawn.delegate = self
        calendarJawn.dataSource = self
        reloadLabels()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // necessary for signup flow (since onboarding profile form blocks data)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(isBeingPresented || isMovingToParent) {
            self.populateLocalUser()
        }
        self.reloadLabels()
    }
    
    // set the names for a user object if we need to
    /**
     Populates the static User object names if necessary, using the flow specified in Discussion section
        - if User.firstName.exists, just reload the labels
        - else if remote database has User.firstName, populate User object with names and reload labels
        - else prompt user for names, then reload labels via viewWillAppear
    */
    func populateLocalUser() {
        if User.firstName == nil {
            self.view.screenLoading()
            // getNamesFromID checks firebase for name info and sets the User static variables firstName and lastName
            User.getNamesFromID((Auth.auth().currentUser?.uid)!) { success in
                if success {
                    // User is successfully updated, so reload the labels accordingly
                    self.reloadLabels()
                } else {
                    self.view.screenLoaded()
                    // present profile form
                    let p = UIStoryboard(name: "OnboardingTest", bundle: nil).instantiateViewController(withIdentifier: "profile")
                    p.modalTransitionStyle = .coverVertical
                    self.present(p, animated: true, completion: nil)
                }
            }
        } else {
            reloadLabels()
        }
    }
    
    // reload all labels
    func reloadLabels() {
        let currMonthNum = currCal.component(.month, from: currDate) - 1
        monthLabel.text = currCal.monthSymbols[currMonthNum]
        prevMonthOutlet.setTitle("< " + currCal.monthSymbols[(currMonthNum + 11) % 12], for: .normal)
        nextMonthOutlet.setTitle(currCal.monthSymbols[(currMonthNum + 1) % 12] + " >", for: .normal)
        if currCal.component(.month, from: Date()) == currCal.component(.month, from: currDate) && currCal.component(.year, from: Date()) == currCal.component(.year, from: currDate) {
            nextMonthOutlet.isEnabled = false
        } else {
            nextMonthOutlet.isEnabled = true
        }
        User.totalLogs { result in self.totalLogs.text = result < 0 ? "?" : String(result) }
        Messages.getLastLog() { m in
            self.lastLogLabel.text = m
            if let lastLog = User.lastLog {
                let state = self.currCal.dateComponents(Set<Calendar.Component>([.minute]), from: lastLog, to: Date()).minute! > 29
                print(self.currCal.dateComponents(Set<Calendar.Component>([.minute]), from: lastLog, to: Date()).minute!)
                self.toggleMoodsEnabled(state)
                self.checkLater.isHidden = state
                self.greetingLabel.text = Messages.getWelcome(!state)
            }
            self.getCalendarIfNeeded() { self.view.screenLoaded() }
        }
        
    }
    
    func toggleMoodsEnabled(_ state: Bool) {
        sadButtonOutlet.isEnabled = state
        neutralButtonOutlet.isEnabled = state
        happyButtonOutlet.isEnabled = state
    }
    
    /**
     Reloads calendar data for month, getting data from server if necessary
         */
    func getCalendarIfNeeded(_ completion: @escaping () -> Void) {
        if monthData.count > 0 {
            self.calendarJawn.reloadData()
            completion()
            return
        }
        
        let month = currCal.component(.month, from: currDate)
        let year = currCal.component(.year, from: currDate)
        
        User.moodsFromMonth(year, month) { s in
            completion()
            guard let x: [Int: LogDay] = s else { return }
            self.monthData = x
            self.calendarJawn.reloadData()
        }
    }
    
    // define a mood
    @objc func registerMood(_ sender: UIButton) {
        currDate = Date()
        // defines a mood passes in necessary aprams (value, date, zip)
        let m = Mood(sender.tag - 60, Date(), "63130")
        self.view.screenLoading()
        
        m.upload({ b in
            if !b {
                // TODO: alert upload error
            }
        }, { b in
            if b {
                // append mood to month data arr
                let dayInt = self.currCal.component(.day, from: self.currDate)
                let d = self.monthData[dayInt]
                d?.moods.append(m)
                self.reloadLabels()
            } else {
                // TODO: alert update error
            }
        })
    }
    
    // instantiate mood buttons
    func setupButtons() {
        sadButtonOutlet.imageView?.contentMode = .scaleAspectFit
        neutralButtonOutlet.imageView?.contentMode = .scaleAspectFit
        happyButtonOutlet.imageView?.contentMode = .scaleAspectFit
        nextMonthOutlet.setTitleColor(UIColor.lightGray, for: .disabled)
        for b:UIButton in [sadButtonOutlet, neutralButtonOutlet, happyButtonOutlet] {
            b.addTarget(self, action: #selector(registerMood(_:)), for: .touchUpInside)
        }
    }
    
    /// self-explanatory - but sets constraints
    func setupCellConstraints() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size: CGFloat = floor((calendarJawn.frame.width - 12) / 7)
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        calendarJawn.collectionViewLayout = layout
    }
    
    // num items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    // sets light gray and regular gray for eligible items in that month's calendar
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarJawn.dequeueReusableCell(withReuseIdentifier: "calendarDay", for: indexPath) as! CalendarCell
        let lastDayIndex = startingWeekdayIndexed + numDaysInMonth - 1
        cell.backgroundColor = (startingWeekdayIndexed ... lastDayIndex).contains(indexPath.row) ? UIColor(rgb: 0xe7e7e7) : UIColor(rgb: 0xf0f0f0)
        guard let day = self.monthData[indexPath.row-(startingWeekdayIndexed-1)] else { return cell }
        cell.backgroundColor = day.color()
        cell.log = day
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let day = self.monthData[indexPath.row-(startingWeekdayIndexed-1)] else { print("no logs associated with this day"); return }
        let vc = UIStoryboard(name: "LogDay", bundle: nil).instantiateViewController(withIdentifier: "LogDayCollection") as! LogDayController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        vc.logDay = day
        vc.dayString = (monthLabel.text ?? "someMonth") + " " + String(indexPath.row - startingWeekdayIndexed) + ", " + currCal.component(.year, from: currDate)
        self.blurEnabled(true)
        self.present(vc, animated: true, completion: nil)
    }
    
    func blurEnabled(_ state: Bool) {
        if state {
            let blur = UIVisualEffectView()
            blur.frame = self.view.frame
            blur.effect = UIBlurEffect(style: .dark)
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(blur)
            }, completion: nil)
        } else {
            for view in self.view.subviews {
                if view.isKind(of: UIVisualEffectView.self) {
                    UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                        view.removeFromSuperview()
                    }, completion: nil)
                }
            }
        }
    }
    
}
