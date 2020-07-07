//
//  ListDeveloperResponse.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 04/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import Foundation

struct ListDeveloperResponse: Codable {

    let count: Int?
    let next: String?
    let previous: String?
    let results: [ListDeveloperResults]?

    private enum CodingKeys: String, CodingKey {
        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }

}

struct ListDeveloperResults: Codable {

    let id: Int?
    let name: String?
    let slug: String?
    let gamesCount: Int?
    let imageBackground: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case slug = "slug"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }

}
