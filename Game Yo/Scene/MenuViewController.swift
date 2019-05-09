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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func showKeyboard1(_ sender: Any) {
        self.nameTextField.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        nameTextField.resignFirstResponder()
    }
}
