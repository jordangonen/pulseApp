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
    
    @IBOutlet var dayHeadingStack: UIStackView!
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var sadButtonOutlet: UIButton!
    @IBOutlet var neutralButtonOutlet: UIButton!
    @IBOutlet var happyButtonOutlet: UIButton!
    @IBOutlet var emotionStackView: UIStackView!
    @IBOutlet var calendarJawn: UICollectionView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var totalLogs: UILabel!
    
    var currDate = Date()
    var currCal = Calendar.current
    var numDaysInMonth: Int {
        return (currCal.range(of: .day, in: .month, for: currDate)?.count)!
    }
    var startingWeekdayIndexed: Int {
        var dc = DateComponents()
        dc.year = currCal.component(.year, from: currDate)
        dc.month = currCal.component(.month, from: currDate)
        return currCal.component(.weekday, from: currCal.date(from: dc)!) - 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateLocalUser()
        self.setupButtons()
        calendarJawn.delegate = self
        calendarJawn.dataSource = self
        setupCellConstraints()
    }
    
    func reloadLabels() {
        monthLabel.text = Calendar.current.monthSymbols[Calendar.current.component(.month, from: currDate) - 1]
        User.totalLogs { result in
            if result < 0 {
                self.totalLogs.text = "Fuck"
            } else {
                self.totalLogs.text = String(result)
            }
        }
    }
    
    func setupButtons() {
        sadButtonOutlet.imageView?.contentMode = .scaleAspectFit
        neutralButtonOutlet.imageView?.contentMode = .scaleAspectFit
        happyButtonOutlet.imageView?.contentMode = .scaleAspectFit
        
        for b:UIButton in [sadButtonOutlet, neutralButtonOutlet, happyButtonOutlet] {
            b.addTarget(self, action: #selector(registerMood(_:)), for: .touchUpInside)
        }
    }
    
    @objc func registerMood(_ sender: UIButton) {
        let m = Mood(sender.tag - 60, Date())
        self.view.screenLoading()
        m.upload({ b in
            self.view.screenLoaded()
            if b {
                print("\nayooo\n")
            } else {
                print("\naynooo\n")
            }
        }, { b in
            if b {
                print("\nupdated\n")
                self.reloadLabels()
            } else {
                print("\ndidn't update\n")
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.populateLocalUser()
    }
    
    func setupCellConstraints() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size: CGFloat = floor((calendarJawn.frame.width - 12) / 7)
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        calendarJawn.collectionViewLayout = layout
    }
    
    func populateLocalUser() {
        if User.firstName == nil {
            self.view.screenLoading()
            User.getNamesFromID((Auth.auth().currentUser?.uid)!) { success in
                if success {
                    self.reloadLabels()
                    self.greetingLabel.text = WelcomeMessage.getMessage()
                    self.view.screenLoaded()
                } else {
                    self.view.screenLoaded()
                    let p = UIStoryboard(name: "OnboardingTest", bundle: nil).instantiateViewController(withIdentifier: "profile")
                    p.modalTransitionStyle = .coverVertical
                    self.present(p, animated: true, completion: nil)
                }
            }
        } else {
            greetingLabel.text = WelcomeMessage.getMessage()
        }
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
        return numDaysInMonth + startingWeekdayIndexed
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarJawn.dequeueReusableCell(withReuseIdentifier: "calendarDay", for: indexPath) as! CalendarCell
        if indexPath.row < startingWeekdayIndexed {
            cell.backgroundColor = UIColor(rgb: 0xEDEFEF)
            return cell
        }
        let sampleLogDay = LogDay()
        sampleLogDay.moods = (0...Int.random(in: 0...3)).map { _ in Mood(Int.random(in: 0...2), Date()) }
        cell.backgroundColor = sampleLogDay.color()
        cell.log = sampleLogDay
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currCell = collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
        print("\navg: \(currCell.log?.avg)")
        print("\ncolor: \(currCell.log?.color())")
        for m in currCell.log!.moods {
            print("\ndate: \(m.dateTime)")
        }
    }
    
}
