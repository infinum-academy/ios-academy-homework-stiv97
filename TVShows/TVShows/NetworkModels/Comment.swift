//
//  Comment.swift
//  TVShows
//
//  Created by Sandro Domitran on 02/08/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import Foundation

struct Comment: Codable  {
    let episodeId: String
    let text: String
    let userEmail: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case episodeId
        case text
        case userEmail
        case id = "_id"
    }
}
