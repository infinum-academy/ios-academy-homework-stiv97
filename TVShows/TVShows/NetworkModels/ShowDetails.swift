//
//  ShowDetails.swift
//  TVShows
//
//  Created by Sandro Domitran on 25/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import Foundation

struct ShowDetails: Codable {
    let type: String
    let title: String
    let description: String
    let imageUrl: String
    let likesCount: Int
    let id: String
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case imageUrl
        case likesCount
        case id = "_id"
    }
}

