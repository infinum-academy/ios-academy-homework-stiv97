//
//  Episode.swift
//  TVShows
//
//  Created by Sandro Domitran on 25/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let id: String
    let season: String
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageUrl
        case episodeNumber
        case id = "_id"
        case season
    }
}

