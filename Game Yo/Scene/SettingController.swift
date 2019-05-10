//
//  SettingController.swift
//  Game Yo
//
//  Created by Huu Nguyen on 9/5/19.
//  Copyright © 2019 Huu Nguyen. All rights reserved.
//

import Foundation
import UIKit

class SettingTableViewController: UITableViewController {
    
    // outlet declaration
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var maxBubbleSlider: UISlider!
    @IBOutlet weak var currentMaxBubble: UILabel!
    @IBOutlet weak var currentTimeMax: UILabel!
    
    // run on load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
    }
    
    // function to save max time on slider
    @IBAction func changeTime(_ sender: Any) {
        let timeMax = Int(timeSlider.value)
        UserDefaults.standard.set(timeMax, forKey: "timeMax")
        currentTimeMax.text = String(timeMax)
    }
    
    // function to save max bubble on slider
    @IBAction func changeMax(_ sender: Any) {
        let max = Int(maxBubbleSlider.value)
        UserDefaults.standard.set( max , forKey: "maxBubble")
        currentMaxBubble.text = String(max)
    }
}
