//
//  TESTLoggedIn.swift
//  Pulse
//
//  Created by Reilly Freret on 11/15/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

class TESTLoggedIn: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var v = Bundle.main.loadNibNamed("CalendarScroller", owner: self, options: nil)?.first as! TESTCalendarView
    
    @IBOutlet var scrollView: UIScrollView!
    
    var yearData = [Int: [LogDay]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v.calendarCollectionView.delegate = self
        v.calendarCollectionView.dataSource = self
        formatCalendarCells(monthView: v)
        scrollView.contentSize.width = view.frame.width
        v.frame = CGRect(x: 0, y: scrollView.frame.minY, width: view.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(v)
        
    }
    
    // collection view stuff
    
    func formatCalendarCells(monthView: TESTCalendarView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size: CGFloat = floor((monthView.calendarCollectionView.frame.width - 12) / 7)
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        monthView.calendarCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("here")
        let cell = v.calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath)
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
    
    override func awakeFromNib() {
        print("awoken")
        let nibName = UINib(nibName: "CalendarCell", bundle: nil)
        v.calendarCollectionView.register(nibName, forCellWithReuseIdentifier: "calendarCell")
    }

}
