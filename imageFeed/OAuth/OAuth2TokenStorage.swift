//
//  OAuth2TokenStorage.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 12.10.2023.
//

import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        get{
            UserDefaults.standard.string(forKey: "token")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}
