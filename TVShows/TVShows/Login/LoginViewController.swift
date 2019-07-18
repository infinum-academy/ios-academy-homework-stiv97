//
//  LoginViewController.swift
//  TVShows
//
//  Created by Sandro Domitran on 05/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

struct User: Codable {
    let email: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginUser: Codable {
    let token: String
}

let parameters: [String: String] = [
    "email": "",
    "password": ""
]

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var rememberButton: UIButton!
    
    private var newUser: User?
    private var loginUser: LoginUser?

    private var username : String {
        if let text = self.usernameTextField.text {
            return text
        } else{
            return ""
        }
    }
    
    private var password : String {
        if let text = self.passwordTextField.text {
            return text
        } else{
            return ""
        }
    }
    
    private lazy var rememberCheckBox = CheckBox(checkedImage: "ic-checkbox-filled", uncheckedImage: "ic-checkbox-empty", button: self.rememberButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = .pink
        registerButton.setTitleColor(.pink, for: .normal)
    }

    @IBAction private func rememberButtonPressed(_ sender: UIButton) {
        rememberCheckBox.pressed()
    }
    
    @IBAction private func loginButtonPressed(_ sender: Any) {
        if checkUsernameAndPassword() {
                SVProgressHUD.show()
                let parameters: [String: String] = [
                    "email": username,
                    "password": password
                ]
                
                Alamofire
                    .request("https://api.infinum.academy/api/users/sessions",
                             method: .post,
                             parameters: parameters,
                             encoding: JSONEncoding.default)
                    .validate()
                    .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                        (response: DataResponse<LoginUser>) in
                        
                        SVProgressHUD.dismiss()
                        switch response.result {
                        case .success(let user):
                            self.loginUser = user
                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as UIViewController
                            self.show(vc, sender: self)
                        case .failure(let error):
                            self.unableToLogin()
                            print("API failure: \(error)")
                        }
                        
                    }
            }
    }
    
    @IBAction private func registerButtonPressed(_ sender: Any) {
        if checkUsernameAndPassword() {
            SVProgressHUD.show()
            let parameters: [String: String] = [
                "email": username,
                "password": password
            ]
            
            Alamofire
                .request("https://api.infinum.academy/api/users",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<User>) in
                    
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let user):
                        self.newUser = user
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as UIViewController
                        self.show(vc, sender: self)
                    case .failure(let error):
                        self.unableToRegister()
                        print("API failure: \(error)")
                    }
                    
            }
        }
    }
    // notify user about login problem
    private func unableToLogin() {
        let alert = UIAlertController(
            title: "Unable to login",
            message: "Please check username and password",
            preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(OKAction)
        
        present(alert, animated: true, completion: nil)
    }
    // notify user about registration problem
    private func unableToRegister() {
        let alert = UIAlertController(
            title: "Unable to register",
            message: "Please check entered email",
            preferredStyle: UIAlertController.Style.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(OKAction)
        
        present(alert, animated: true, completion: nil)
    }
    // check for empty fields and notify user if any
    private func checkUsernameAndPassword() -> Bool {
        if username.isEmpty || password.isEmpty {
            let alert = UIAlertController(
                title: "Empty Fields",
                message: "Please fill username and password",
                preferredStyle: UIAlertController.Style.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OKAction)
            
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}

public extension UIColor {
    static let pink = UIColor(
        red: 255/255,
        green: 117/255,
        blue: 140/255,
        alpha: 1
    )
}
