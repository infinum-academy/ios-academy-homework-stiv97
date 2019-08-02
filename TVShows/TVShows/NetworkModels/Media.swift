//
//  Media.swift
//  TVShows
//
//  Created by Sandro Domitran on 01/08/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import Foundation

struct Media: Codable  {
    let path: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case path
        case type
        case id = "_id"
    }
}
