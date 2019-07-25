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

    var loginUser: LoginUser? = nil
    var shows: [Show]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        
        guard let token = loginUser?.token else { return }
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
                    print(self.shows)
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
        
    }
}
