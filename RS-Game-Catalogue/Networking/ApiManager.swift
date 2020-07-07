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

    private init() { }

    func getGames(by date: String, id: String, ordering: String = "", completed: @escaping (Result<GameResponse, RSError>) -> Void) {

        var endpoint = Constants.Api.BASE_URL

        if ordering == "" {
             endpoint += "api/games?dates=\(date)&platforms=\(id)"
        } else {
            endpoint += "api/games?dates=\(date)&platforms=\(id)&ordering=\(ordering)"
        }

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
                    let games = try decoder.decode(GameResponse.self, from: data)
                completed(.success(games))
            } catch let error as NSError {
                print(error)
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }

    func getDevelopers(completed: @escaping (Result<ListDeveloperResponse, RSError>) -> Void) {

        let endpoint = Constants.Api.BASE_URL + "api/developers"

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
                    let games = try decoder.decode(ListDeveloperResponse.self, from: data)
                completed(.success(games))
            } catch let error as NSError {
                print(error)
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }

    func getGamesByDevelopers(id: Int, completed: @escaping (Result<GameResponse, RSError>) -> Void) {

        let endpoint = Constants.Api.BASE_URL + "api/games?page_size=15&platforms=3&ordering=-rating&developers=\(id)"

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
                    let games = try decoder.decode(GameResponse.self, from: data)
                completed(.success(games))
            } catch let error as NSError {
                print(error)
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }

    func getGameDetail(by id: Int, completed: @escaping (Result<GameDetailResponse, RSError>) -> Void) {

        let endpoint = Constants.Api.BASE_URL + "api/games/\(id)"

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
                    let games = try decoder.decode(GameDetailResponse.self, from: data)
                completed(.success(games))
            } catch let error as NSError {
                print(error)
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }
}
