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
    }

    @IBAction private func rememberButtonPressed(_ sender: UIButton) {
        rememberCheckBox.pressed()
    }
    
    @IBAction private func loginButtonPressed(_ sender: Any) {
        guard checkUsernameAndPassword() else { return }
        let parameters: [String: String] = [
            "email": username,
            "password": password
        ]
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
    // alert user with message and title
    private func alertMessage(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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

