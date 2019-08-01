//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Sandro Domitran on 25/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

final class ShowDetailsViewController: UIViewController {
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var episodeCountLabel: UILabel!
    @IBOutlet private weak var episodeTableView: UITableView!
    
    var loginUser: LoginUser?
    var showId: String?
    
    private var showDetails: ShowDetails?{
        didSet {
            titleLabel.text = showDetails?.title
            descriptionLabel.text = showDetails?.description
            if let imageUrl = showDetails?.imageUrl {
                let url = URL(string: "https://api.infinum.academy" + imageUrl)
                showImage.kf.setImage(with: url)
            }
        }
    }
    private var episodes: [Episode]? {
        didSet {
            episodeCountLabel.text = String(episodes!.count)
            episodeTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        episodeTableView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        fetchShowDetails()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func addNewEpisode(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEpisodeViewController") as! AddEpisodeViewController
        vc.showId = showId
        vc.loginUser = loginUser
        vc.mediaId = showDetails?.id
        vc.delegate = self
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension ShowDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let episodes = self.episodes else { return 0 }
        return episodes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodeTableView.dequeueReusableCell(withIdentifier: "EpisodeCell") as! EpisodeCell
        if let episode = episodes?[indexPath.row] {
            cell.setSeasonAndEpisodeNumber(season: episode.season, episode: episode.episodeNumber)
            cell.setEpisodeTitle(title: episode.title)
        }
        return cell
    }
}


extension ShowDetailsViewController {
    private func fetchShowDetails(){
        guard let token = loginUser?.token
            else {
                print("Invalid user")
                return
        }
        guard let id = showId
            else {
                print("Invalid show")
                return
        }
        SVProgressHUD.show()
        let headers = ["Authorization" : token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/"+id,
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                [weak self] (response: DataResponse<ShowDetails>) in
                
                guard let self = self else { return }
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let showDetails):
                    self.showDetails = showDetails
                    self.fetchEpisodes()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    private func fetchEpisodes(){
        guard let token = loginUser?.token
            else {
                print("Invalid user")
                return
        }
        guard let id = showId
            else {
                print("Invalid show")
                return
        }
        SVProgressHUD.show()
        let headers = ["Authorization" : token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/"+id+"/episodes",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                [weak self] (response: DataResponse<[Episode]>) in
                
                guard let self = self else { return }
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let episodes):
                    self.episodes = episodes
                case .failure(let error):
                    self.alertMessage(title: "Failed", message: "API failure")
                    print(error)
                }
        }
    }
}


extension ShowDetailsViewController: AddNewEpisodeDelegate {
    func didSucceed() {
        fetchEpisodes()
    }
}
