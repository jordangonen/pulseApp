//
//  DayViewController.swift
//  Pulse
//
//  Created by Nofal Zubair on 11/30/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class DayViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource{
    
    var backgroundColor: UIColor!
    @IBOutlet weak var viewer: UIView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var maxTemp: String!
    var minTemp: String!
    var rows: Int!
    
    var moodArr: [Mood] = []
    

    
    // this viewcontroller was created programmatically so several lines of formatting included
    // everything called in viewdidload so it loads every time user pulls up the movie details
    override func viewDidLoad() {
        super.viewDidLoad()
        viewer.backgroundColor = backgroundColor
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
        tableView.dataSource = self
        print(moodArr)

    }
    override func viewWillAppear(_ animated: Bool) {
//        self.populateData()

    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        
        let val = moodArr[indexPath.row].value
        let time = moodArr[indexPath.row].dateTime!
        var cleanDate: String!
        
        
        let timeString = ("\(time)")
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, h:mm a"

        if let date = dateFormatterGet.date(from: timeString) {
            cleanDate = dateFormatterPrint.string(from: date)
            print(dateFormatterPrint.string(from: date))
        } else {
            print("There was an error decoding the string")
        }
        
        
        switch val {
        case 0:
            cell.textLabel?.text = "☹️ recorded on: " + "\(cleanDate!)"
        case 1:
            cell.textLabel?.text = "😐 recorded on: " + "\(cleanDate!)"
        case 2:
            cell.textLabel?.text = "😃 recorded on: " + "\(cleanDate!)"
        default:
            print("nada exists in this jawn")
        }
        
        return cell
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
