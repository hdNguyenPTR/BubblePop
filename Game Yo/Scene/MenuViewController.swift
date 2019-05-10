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
    
    // outlet declaration
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    // run on menu finish loading
    override func viewWillAppear(_ animated: Bool) {
        //local variable declaration
        let bubbleS = UserDefaults.standard.string(forKey: "maxBubble")
        let timeS = UserDefaults.standard.string(forKey: "timeMax")
        // set default settings
        if bubbleS == nil  {
            UserDefaults.standard.set(15, forKey: "maxBubble")
        }
        if timeS == nil  {
            UserDefaults.standard.set(60, forKey: "timeMax")
        }
        // dismiss keyboard event
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // action to show keyboard
    @IBAction func showKeyboard1(_ sender: Any) {
        self.nameTextField.becomeFirstResponder()
    }

    //action to make sure there is a player name
    @IBAction func finishInput(_ sender: Any) {
        // check if there is player name
        if nameTextField.text != nil && nameTextField.text != "" {
            playButton.isEnabled = true
        }
        else{
            playButton.isEnabled = false
        }
    }
    
    // save player name to userdefaults
    @IBAction func gameStart(_ sender: Any) {
        if nameTextField.text != nil{
            UserDefaults.standard.set( nameTextField.text! , forKey: "currentPlayer")
        }
    }
    
    // function to dismiss keyboard
    @objc func dismissKeyboard() {
        nameTextField.resignFirstResponder()
    }
}
