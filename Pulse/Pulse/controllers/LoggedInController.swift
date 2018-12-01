//
//  LoggedInController.swift
//  Pulse
//
//  Created by Reilly Freret on 11/9/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoggedInController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    // data management variables
    var monthData = [Int: LogDay]()
    var currDate = Date()
    var currCal = Calendar.current
    var numDaysInMonth: Int {
        return (currCal.range(of: .day, in: .month, for: currDate)?.count)!
    }
    
    var dayArr: [Mood] = []

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateLocalUser()
        self.setupButtons()
        self.setupCellConstraints()
        calendarJawn.delegate = self
        calendarJawn.dataSource = self
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // initialize periodic refreshes
        
    }
    
    // necessary for signup flow (since onboarding profile form blocks data)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(isBeingPresented || isMovingToParentViewController) {
            self.populateLocalUser()
        }
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
    
    func reloadLabels() {
        greetingLabel.text = Messages.getWelcome()
        monthLabel.text = Calendar.current.monthSymbols[Calendar.current.component(.month, from: currDate) - 1]
        User.totalLogs { result in self.totalLogs.text = result < 0 ? "?" : String(result) }
        Messages.getLastLog() { m in self.lastLogLabel.text = m }
        self.getCalendarIfNeeded() { self.view.screenLoaded() }
    }
    
    /**
     Reloads calendar data for month, getting data from server if necessary
     
     - Important: completion handler MUST call .screenLoaded() at some point
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
    
    func fillDayArr(day: Int) -> [Mood] {
        dayArr = (monthData[day]?.moods!)!
        return dayArr
    }
    
    
    
    @objc func registerMood(_ sender: UIButton) {
        let m = Mood(sender.tag - 60, Date())
        self.view.screenLoading()
        m.upload({ b in
            if !b {
                // TODO: alert upload error
            }
        }, { b in
            if b {
                let dayInt = self.currCal.component(.day, from: self.currDate)
                if let d = self.monthData[dayInt] {
                    d.moods.append(m)
                } else {
                    let d = LogDay()
                    d.moods.append(m)
                    self.monthData[dayInt] = d
                }
                self.reloadLabels()
            } else {
                // TODO: alert update error
            }
        })
        
    }
    
    func setupButtons() {
        sadButtonOutlet.imageView?.contentMode = .scaleAspectFit
        neutralButtonOutlet.imageView?.contentMode = .scaleAspectFit
        happyButtonOutlet.imageView?.contentMode = .scaleAspectFit
        
        for b:UIButton in [sadButtonOutlet, neutralButtonOutlet, happyButtonOutlet] {
            b.addTarget(self, action: #selector(registerMood(_:)), for: .touchUpInside)
        }
    }
    
    /// Pretty self-explanatory huh
    func setupCellConstraints() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size: CGFloat = floor((calendarJawn.frame.width - 12) / 7)
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        calendarJawn.collectionViewLayout = layout
    }
    
    
    
    // Notes for whichever mf has to implement pagination on this guy:
    // replace mainCalendarView with a UIScrollView
    // or like use the numberOfSectionsFor function
    // extend something similar to the onboarding scroll thing
    // that means nest this shit in a horizontally-enableed scroll view with pagination enabled
    // probably set the content width to full (instead of just to the outer scrollview
    // iss easy calm down
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // gonna have to add to this when we have multiple months showing
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarJawn.dequeueReusableCell(withReuseIdentifier: "calendarDay", for: indexPath) as! CalendarCell
        let lastDayIndex = startingWeekdayIndexed + numDaysInMonth - 1
        cell.backgroundColor = (startingWeekdayIndexed ... lastDayIndex).contains(indexPath.row) ? UIColor(rgb: 0xe7e7e7) : UIColor(rgb: 0xf0f0f0)
        guard let day = self.monthData[indexPath.row - 3] else { return cell }
        cell.backgroundColor = day.color()
        cell.log = day
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let currCell = collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
//        if let logDay = currCell.log {
//            
//        }
        
        let selectedDate = "\(currCal.component(.year, from: currDate))" + "-" + "\(currCal.component(.month, from: currDate))" + "-" + "\(indexPath.row-3)"
        
        let nextDay = "\(currCal.component(.year, from: currDate))" + "-" + "\(currCal.component(.month, from: currDate))" + "-" + "\(indexPath.row-2)"
        
        
        do{
            let url = URL(string: "https://api.weatherbit.io/v2.0/history/daily?city=Raleigh,NC&start_date=" + "\(selectedDate)" + "&end_date=" + "\(nextDay)" + "&units=I&key=0d89f91dbfe44f9591d38429d21110e3")
            
            let info = try Data(contentsOf: url!)
            self.weatherResults = try! JSONDecoder().decode(Weather.self, from: info)
//            print(weatherResults?.data)
        }
        catch{
            self.weatherResults = nil
        }
        
        let data = weatherResults?.data
        let maxTempValue = "High Temp:" + "\(data![0].max_temp!)"
        let minTempValue = "Low Temp:" + "\(data![0].min_temp!)"
        
        //        guard let maxTemp = weatherResults?.data else {return}
        //        print(maxTemp)
        
        let storyboard = UIStoryboard(name: "DayView", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "dayview") as! DayViewController
        vc.backgroundColor = UIColor.clear
        vc.maxTemp = maxTempValue
        vc.minTemp = minTempValue
        
//        print(indexPath.row-3)
        vc.moodArr = fillDayArr(day: indexPath.row-3)

        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
