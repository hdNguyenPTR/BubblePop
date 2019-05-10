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
        let bubbleS = UserDefaults.standard.string(forKey: "maxBubble")
        let timeS = UserDefaults.standard.string(forKey: "timeMax")
        if bubbleS == nil  {
            UserDefaults.standard.set(15, forKey: "maxBubble")
        }
        if timeS == nil  {
            UserDefaults.standard.set(60, forKey: "timeMax")
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func showKeyboard1(_ sender: Any) {
        self.nameTextField.becomeFirstResponder()
    }
    
    @IBAction func scoreButton(_ sender: Any) {
    }
    //
    @IBAction func finishInput(_ sender: Any) {
        if nameTextField.text != nil && nameTextField.text != "" {
            playButton.isEnabled = true
        }
        else{
            playButton.isEnabled = false
        }
    }
    
    @IBAction func gameStart(_ sender: Any) {
        if nameTextField.text != nil{
            UserDefaults.standard.set( nameTextField.text! , forKey: "currentPlayer")
        }
    }
    
    @objc func dismissKeyboard() {
        nameTextField.resignFirstResponder()
    }
}
