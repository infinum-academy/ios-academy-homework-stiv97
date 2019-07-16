//
//  LoginViewController.swift
//  TVShows
//
//  Created by Sandro Domitran on 05/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet weak var rememberButton: UIButton!
    
    private lazy var rememberCheckBox = CheckBox(checkedImage: "ic-checkbox-filled", uncheckedImage: "ic-checkbox-empty", button: self.rememberButton)
 
    
   private let pink = UIColor(
        red: 255/255,
        green: 117/255,
        blue: 140/255,
        alpha: 1
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = pink
        createAccountButton.setTitleColor(pink, for: .normal)
    }

    @IBAction func rememberButtonPressed(_ sender: UIButton) {
        rememberCheckBox.pressed()
    }

}
