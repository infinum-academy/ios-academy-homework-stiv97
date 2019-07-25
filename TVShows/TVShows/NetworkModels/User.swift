//
//  User.swift
//  TVShows
//
//  Created by Sandro Domitran on 24/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}
