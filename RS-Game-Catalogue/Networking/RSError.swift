//
//  RSError.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import Foundation

enum RSError: String, Error {

    case invalidURL = "Invalid URL"
    case invalidData = "Invalid data"
    case invalidResponse = "Invalid response from the server, please try again"
    case somethingWrong = "Something wrong server :("
}
