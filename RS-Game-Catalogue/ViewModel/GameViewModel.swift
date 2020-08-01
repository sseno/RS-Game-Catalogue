//
//  GameViewModel.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 01/08/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import Foundation

class GameViewModel {

    var gameResult: GameResults
    var gameRealmResult = [GameRealmResult]()

    init(data: GameResults) {
        self.gameResult = data
    }

    var genres: String {
        var joinedGenre = ""
        if let gendres = gameResult.genres {
            let arr = gendres.map{ $0.name ?? ""}
            joinedGenre = arr.joined(separator: ", ")
        }
        return joinedGenre
    }

    func loadBookmarkedGames() {
        let listOfGames = GameRealmResult.get(isBookmarked: true)
        gameRealmResult.append(contentsOf: listOfGames.reversed())
    }

    var isBookmarked: Bool {
        loadBookmarkedGames()
        var bookmark = false
        for itemBookmarked in gameRealmResult {
            if (itemBookmarked.id == self.gameResult.id) {
                if itemBookmarked.isBookmarked {
                    bookmark = true
                } else {
                    bookmark = false
                }
            }
        }
        return bookmark
    }

}
