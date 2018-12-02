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
import CoreLocation

class LoggedInController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate  {
    
    var postal = ""
    
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
    
    
    let locationMgr = CLLocationManager()

    func fetchCurrLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted {
            print("\nlocation restricted")
            presentLocationNotification()
            return
        } else if authStatus == .notDetermined {
            print("\nlocation not determined")
            locationMgr.requestWhenInUseAuthorization()
            return
        } else {
            print("\nstarting update location...")
            locationMgr.delegate = self
            locationMgr.startUpdatingLocation()
        }
        return
    }
    
    func presentLocationNotification() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "To view local weather, change your preferences.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\nstarting location manager...")
        let lastLoc = locations.last!
        convertLocPlacemark(location: lastLoc) { (placeMarker) -> () in
            let postCode = placeMarker?.postalCode
            print(String(postCode!))
            self.setCode(postCode: postCode!)

        }
    }
    func setCode(postCode: String) {
        postal = postCode
        

//        let alert = UIAlertController(title: "Updated Current Location", message: "Your Zip Code is \(String(postCode))", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//
//        self.present(alert, animated: true)

    }
    
    func convertLocPlacemark(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> ()) {
        print("\nconversion function successfully called")
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                print("\nconversion received no error")
                completionHandler(placemarks?[0])
            } else {
                print("\nconversion received error: \(String(describing: error))")
                completionHandler(nil)
            }
        })
        locationMgr.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Uh-oh", message: "Something went wrong while trying to retrieve your location.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: {(action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
//            self.getTaxInfo(nil)
        })
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
    }


    
    
    // data management variables
    var monthData = [Int: LogDay]()
    var currDate = Date()
    var currMonth = Date()
    var currCal = Calendar.current
    var numDaysInMonth: Int {
        return (currCal.range(of: .day, in: .month, for: currDate)?.count)!
    }
    
    @IBAction func nextButton(_ sender: Any) {
        currDate = currCal.date(byAdding: .month, value: +1, to: currDate)!
        reloadLabels()
        self.calendarJawn.reloadData()
     
        self.view.screenLoading()

        let month = currCal.component(.month, from: currDate)
        let year = currCal.component(.year, from: currDate)
        User.moodsFromMonth(year, month, postal) { s in
            guard let x: [Int: LogDay] = s else { return }
            self.monthData = x
            self.calendarJawn.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.view.screenLoaded()
            }
        }
        

    }
    
    @IBAction func prevButton(_ sender: Any) {
        currDate = currCal.date(byAdding: .month, value: -1, to: currDate)!
        reloadLabels()
        self.calendarJawn.reloadData()
        self.view.screenLoading()
        
        let month = currCal.component(.month, from: currDate)
        let year = currCal.component(.year, from: currDate)
        User.moodsFromMonth(year, month, postal) { s in
            guard let x: [Int: LogDay] = s else { return }
            self.monthData = x
            self.calendarJawn.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.view.screenLoaded()
            }
        }
      

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
        
        fetchCurrLocation()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
        }
        
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
        
        User.moodsFromMonth(year, month, postal) { s in
            completion()
            guard let x: [Int: LogDay] = s else { return }
            self.monthData = x
            self.calendarJawn.reloadData()
        }
    }
    
    func fillDayArr(day: Int) -> [Mood] {
        if monthData[day] != nil {
            dayArr = (monthData[day]?.moods!)!
            return dayArr
        }
        dayArr = []
        return dayArr
        
    }
    
    @objc func registerMood(_ sender: UIButton) {
        currDate = Date()
        let m = Mood(sender.tag - 60, Date(), postal)
        self.view.screenLoading()
        m.upload({ b in
            if !b {
                // TODO: alert upload error
            }
        }, { b in
            if b {
                let dayInt = self.currCal.component(.day, from: self.currDate)
                let d = self.monthData[dayInt]
                d?.moods.append(m)
                
//                if let d = self.monthData[dayInt] {
//                    print("INHEREEEE")
//                    d.moods.append(m)
//                } else {
//                    let d = LogDay()
//                    print(d)
//                    d.moods.append(m)
//                    self.monthData[dayInt] = d
//                }
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
        guard let day = self.monthData[indexPath.row-(startingWeekdayIndexed-1)] else { return cell }
        cell.backgroundColor = day.color()
        cell.log = day
        return cell
    }
    var tempPostal = ""
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let currCell = collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
//        if let logDay = currCell.log {
//            
//        }
        
        let selectedDate = "\(currCal.component(.year, from: currDate))" + "-" + "\(currCal.component(.month, from: currDate))" + "-" + "\(indexPath.row-(startingWeekdayIndexed-1))"
        
        let nextDay = "\(currCal.component(.year, from: currDate))" + "-" + "\(currCal.component(.month, from: currDate))" + "-" + "\(indexPath.row-(startingWeekdayIndexed-2))"
        
        let m = currCal.component(.month, from: currDate)
        
        if(currCal.component(.month, from: currMonth) > currCal.component(.month, from: currDate)) {
            print("cannot click in future months")
//            print("this is" + "\(self.monthData[indexPath.row-(startingWeekdayIndexed-1)]?.moods.count)")

            return
        }
        
        if (self.monthData[indexPath.row-(startingWeekdayIndexed-1)]?.moods.count) == nil {
            print("this is nil")
            return
        }
        
        
        if((indexPath.row-(startingWeekdayIndexed-1) > currCal.component(.day, from: currDate)) && currCal.component(.month, from: currMonth) == m) {
            print ("this date is out of range")
            
            return
        }
        
        if((indexPath.row-(startingWeekdayIndexed))<0) {
            print("also out of range")
            return
        }
        

//        if (self.monthData[indexPath.row-(startingWeekdayIndexed)]?.moods.count)! == 0 {
//            print("empty day")
//            return
//        }
            
//        if((indexPath.row-(startingWeekdayIndexed-1)) < currCal.component(.day, from: currDate) && ((monthData[indexPath.row-(startingWeekdayIndexed-1)]?.moods.count)! < 1)){
//            print("does this work")
//            return
//        }


        


        else {

        do{
        
        fetchCurrLocation()
            
            print("this is" + "\(self.monthData[indexPath.row-(startingWeekdayIndexed-1)]?.moods.count)")


         tempPostal = (self.monthData[indexPath.row-(startingWeekdayIndexed-1)]?.moods[0].zipCode)!
            
            print("the postal is " + "\(monthData[indexPath.row-(startingWeekdayIndexed-1)]?.moods[0].zipCode)")
            
            let url = URL(string: "https://api.weatherbit.io/v2.0/history/daily?postal_code=" + "\(tempPostal)" + "&country=US&start_date=" + "\(selectedDate)" + "&end_date=" + "\(nextDay)" + "&units=I&key=0d89f91dbfe44f9591d38429d21110e3")
            
            print(url!)
            
            let info = try Data(contentsOf: url!)
            self.weatherResults = try! JSONDecoder().decode(Weather.self, from: info)
        }
        catch{
            self.weatherResults = nil
        }
        
        let data = weatherResults?.data
        
            
        let maxTempValue = "High Temp: " + "\(data![0].max_temp!)" + "°"
        let minTempValue = "Low Temp: " + "\(data![0].min_temp!)" + "°"

        let storyboard = UIStoryboard(name: "DayView", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "dayview") as! DayViewController
        vc.backgroundColor = UIColor.clear
        vc.maxTemp = maxTempValue
        vc.minTemp = minTempValue
        vc.zip = tempPostal
        
        vc.moodArr = fillDayArr(day: indexPath.row-(startingWeekdayIndexed-1))

        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
    
}
