//
//  CommentsCell.swift
//  TVShows
//
//  Created by Sandro Domitran on 02/08/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import Foundation
import UIKit

class CommentsCell: UITableViewCell {
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func setUsernameLabel(username: String) {
        usernameLabel.text = username
    }
    
    func setCommentLabel(comment:String){
        commentLabel.text = comment
    }
}
