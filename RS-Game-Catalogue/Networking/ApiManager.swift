//
//  ApiManager.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import Foundation

class ApiManager {

    static let shared = ApiManager()
    private let baseURL = "https://api.rawg.io/"

    private init() { }

    func getLatestReleased(by date: String, id: String, completed: @escaping (Result<GameResponse, RSError>) -> Void) {
        let endpoint = baseURL + "api/games?dates=\(date)&platforms=\(id)"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.somethingWrong))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let games = try decoder.decode(GameResponse.self, from: data)
                completed(.success(games))
            } catch let error as NSError {
                print(error)
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }
}
