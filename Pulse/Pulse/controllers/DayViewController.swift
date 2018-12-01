//
//  DayViewController.swift
//  Pulse
//
//  Created by Nofal Zubair on 11/30/18.
//  Copyright © 2018 Reilly Freret. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource{
    
    var backgroundColor: UIColor!
    @IBOutlet weak var viewer: UIView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    
    var maxTemp: String!
    var minTemp: String!
    
    // this viewcontroller was created programmatically so several lines of formatting included
    // everything called in viewdidload so it loads every time user pulls up the movie details
    override func viewDidLoad() {
        super.viewDidLoad()
        viewer.backgroundColor = backgroundColor
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
        tableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
