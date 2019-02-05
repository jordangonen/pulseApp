//
//  LogDayController.swift
//  Pulse
//
//  Created by Reilly Freret on 1/8/19.
//  Copyright © 2019 Reilly Freret. All rights reserved.
//

import Foundation
import UIKit

protocol BlurDelegate: class {
    func blurEnabled(_ state: Bool)
}

class LogDayController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var closeModal: UIButton!
    weak var delegate: BlurDelegate?
    @IBAction func closeModalAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.blurEnabled(false)
    }
    @IBOutlet var dayCollection: UICollectionView!
    
    var logDay: LogDay?
    var dayString: String?
    
    override func viewDidLoad() {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dayCollection.dequeueReusableCell(withReuseIdentifier: "LogDayCollectionCell", for: indexPath)
        return cell
    }
    
    
}
