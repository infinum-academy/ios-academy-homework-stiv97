//
//  ShowCell.swift
//  TVShows
//
//  Created by Sandro Domitran on 25/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit
import Kingfisher

class ShowCell: UITableViewCell {
    @IBOutlet private weak var showImageView: UIImageView!
    
    @IBOutlet private weak var showTitleLabel: UILabel!
    
    
    func setTitle(title: String) {
        showTitleLabel.text = title
    }
    
    func setImage(imageUrl: String) {
        let url = URL(string: "https://api.infinum.academy" + imageUrl)
        showImageView.kf.setImage(with: url)
    }
    

}
