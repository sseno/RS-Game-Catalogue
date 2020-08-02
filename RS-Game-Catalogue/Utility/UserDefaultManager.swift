//
//  UserDefaultManager.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/08/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import Foundation

class UserDefaultManager {

    static let keyCityUser = "keyCityUser"
    static let keyEmailUser = "keyEmailUser"
    static let instance = UserDefaultManager()

    let userDefaults: UserDefaults

    private init() {
        self.userDefaults = UserDefaults.standard
    }

    var userCity: String {
        get {
            if let userCity = userDefaults.object(forKey: UserDefaultManager.keyCityUser) as? String {
                return userCity
            } else {
                return "Yogyakarta"
            }
        }
        set(userCity) {
            userDefaults.set(userCity, forKey:  UserDefaultManager.keyCityUser)
        }
    }

    var userEmail: String {
        get {
            if let userEmail = userDefaults.object(forKey: UserDefaultManager.keyEmailUser) as? String {
                return userEmail
            } else {
                return "rohmatsuseno@gmail.com"
            }
        }
        set(userEmail) {
            userDefaults.set(userEmail, forKey:  UserDefaultManager.keyEmailUser)
        }
    }
}
