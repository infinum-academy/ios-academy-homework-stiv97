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

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var rememberButton: UIButton!
    
    private var newUser: User?
    private var loginUser: LoginUser?

    private var username : String {
        if let text = usernameTextField.text {
            return text
        } else{
            return ""
        }
    }
    
    private var password : String {
        if let text = passwordTextField.text {
            return text
        } else{
            return ""
        }
    }
    
    private lazy var rememberCheckBox = CheckBox(checkedImage: "ic-checkbox-filled", uncheckedImage: "ic-checkbox-empty", button: rememberButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = .pink
        registerButton.setTitleColor(.pink, for: .normal)
        
        let username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        if !username.isEmpty {
            usernameTextField.text = username
        }
        
        let password = UserDefaults.standard.string(forKey: "password") ?? ""
        if !password.isEmpty {
            passwordTextField.text = password
        }
        
        if !username.isEmpty && !password.isEmpty {
            rememberCheckBox.pressed()
        }
    }

    @IBAction private func rememberButtonPressed(_ sender: UIButton) {
        rememberCheckBox.pressed()
    }
    
    @IBAction private func loginButtonPressed(_ sender: Any) {
        guard checkUsernameAndPassword() else {
            if username.isEmpty {
                usernameTextField?.shake()
            }
            if password.isEmpty {
                passwordTextField?.shake()
            }
            return
        }
        let parameters: [String: String] = [
            "email": username,
            "password": password
        ]
        if rememberCheckBox.isChecked {
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(password, forKey: "password")
        }
        loginUser(parameters: parameters)
    }
    
    @IBAction private func registerButtonPressed(_ sender: Any) {
        guard checkUsernameAndPassword() else { return }
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
                [weak self] (response: DataResponse<User>) in
                    
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                switch response.result {
                case .success(let user):
                    self.newUser = user
                    self.loginUser(parameters: parameters)
                case .failure(let error):
                    self.alertMessage(title: "Unable to register", message: "Please check entered email")
                    print("API failure: \(error)")
                }
        }
    }
    // Alamofire login request
    private func loginUser(parameters: [String:String]){
        SVProgressHUD.show()
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
               [weak self] (response: DataResponse<LoginUser>) in
                
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                switch response.result {
                case .success(let user):
                    self.loginUser = user
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                    vc.loginUser = self.loginUser
                    self.show(vc, sender: self)
                case .failure(let error):
                    self.alertMessage(title: "Unable to login", message: "Please check username and password")
                    print("API failure: \(error)")
                }
        }
    }
    // check for empty fields and notify user if any
    private func checkUsernameAndPassword() -> Bool {
        if username.isEmpty || password.isEmpty {
            alertMessage(title: "Empty Fields", message: "Please fill username and password")
            return false
        }
        return true
    }
}

extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}

