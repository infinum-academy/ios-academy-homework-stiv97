//
//  EpisodeCell.swift
//  TVShows
//
//  Created by Sandro Domitran on 26/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var seasonAndEpisodeLabel: UILabel!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    
    func setSeasonAndEpisodeNumber(season:String, episode: String) {
        seasonAndEpisodeLabel.textColor = .pink
        seasonAndEpisodeLabel.text = "S" + season + " Ep" + episode
    }
    
    func setEpisodeTitle(title: String) {
        episodeTitleLabel.text = title
    }
}
