//
//  MenuViewController.swift
//  Game Yo
//
//  Created by Huu Nguyen on 9/5/19.
//  Copyright © 2019 Huu Nguyen. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addNewPlayer: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(8, forKey: "maxBubble")
        UserDefaults.standard.set(60, forKey: "timeMax")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func showKeyboard1(_ sender: Any) {
        self.nameTextField.becomeFirstResponder()
    }
    
    @IBAction func scoreButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setPoints(name: "testin", score: 123)
    }
    
    @IBAction func finishInput(_ sender: Any) {
        if nameTextField.text != nil{
            playButton.isEnabled = true
        }
    }
    
    @IBAction func gameStart(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if nameTextField.text != nil{
            appDelegate.setPoints(name: nameTextField.text!, score: 0)
        }
    }
    
    @objc func dismissKeyboard() {
        nameTextField.resignFirstResponder()
    }
}
