//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Sandro Domitran on 01/08/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit
import Kingfisher

class EpisodeDetailsViewController: UIViewController {
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var seasonAndEpisodeLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    
    var loginUser: LoginUser?
    var episode: Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seasonAndEpisodeLabel.textColor = .pink
        if let episode = self.episode {
            episodeTitleLabel.text = episode.title
            seasonAndEpisodeLabel.text = "S" + episode.season + " E" + episode.episodeNumber
            episodeDescriptionLabel.text = episode.description
            let url = URL(string: "https://api.infinum.academy" + episode.imageUrl)
            episodeImageView.kf.setImage(with: url)
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController else { return }
        vc.loginUser = loginUser
        vc.episodeId = episode?.id
        self.show(vc, sender: self)
    }
    
}
