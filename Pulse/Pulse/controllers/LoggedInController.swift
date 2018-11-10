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
    
    // Notes for whichever mf has to implement pagination on this guy:
    // replace mainCalendarView with a UIScrollView
    // extend something similar to the onboarding scroll thing
    // that means nest this shit in a horizontally-enableed scroll view with pagination enabled
    // probably set the content width to full (instead of just to the outer scrollview
    // iss easy calm down
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarJawn.dequeueReusableCell(withReuseIdentifier: "calendarDay", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("\n\nayooo\n")
        let dim = floor(calendarJawn.frame.width / 7)
        return CGSize(width: dim, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        print("\n\ncheeeers\n")
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @IBOutlet var dayHeadingStack: UIStackView!
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var sadButtonOutlet: UIButton!
    @IBOutlet var neutralButtonOutlet: UIButton!
    @IBOutlet var happyButtonOutlet: UIButton!
    @IBOutlet var emotionStackView: UIStackView!
    @IBOutlet var calendarJawn: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateLocalUser()
        sadButtonOutlet.imageView?.contentMode = .scaleAspectFit
        neutralButtonOutlet.imageView?.contentMode = .scaleAspectFit
        happyButtonOutlet.imageView?.contentMode = .scaleAspectFit
        
        calendarJawn.delegate = self
        calendarJawn.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.populateLocalUser()
    }
    
    func populateLocalUser() {
        if User.firstName == nil {
            self.view.screenLoading()
            User.getNamesFromID((Auth.auth().currentUser?.uid)!) { success in
                if success {
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
}
