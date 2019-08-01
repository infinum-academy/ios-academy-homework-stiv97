//
//  HomeViewController.swift
//  TVShows
//
//  Created by Sandro Domitran on 17/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD


class HomeViewController: UIViewController {
    
    @IBOutlet private weak var showsTableView: UITableView!
    var loginUser: LoginUser?
    private var shows: [Show]? {
        didSet {
            self.showsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.title = "Shows"
        
        
        let logoutItem = UIBarButtonItem.init(
            image: UIImage(named: "ic-logout"),
            style: .plain,
            target: self,
            action:
            #selector(_logoutActionHandler))
            navigationItem.leftBarButtonItem = logoutItem

        guard let token = loginUser?.token
            else {
                print("Invalid user")
                return
        }
        SVProgressHUD.show()
        let headers = ["Authorization" : token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                [weak self] (response: DataResponse<[Show]>) in
                
                guard let self = self else { return }
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let shows):
                    self.shows = shows
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    @objc private func _logoutActionHandler() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        navigationController?.setViewControllers([vc], animated: true)
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shows = self.shows else { return 0 }
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showsTableView.dequeueReusableCell(withIdentifier: "ShowCell") as! ShowCell
        if let show = shows?[indexPath.row] {
            cell.setTitle(title: show.title)
            cell.setImage(imageUrl: show.imageUrl)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.shows?[indexPath.row].id else { return }
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as? ShowDetailsViewController else { return }
        vc.showId = id
        vc.loginUser = loginUser
        
        self.show(vc, sender: self)
    }
}
