//
//  OAuth2TokenStorage.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 12.10.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let key = KeychainWrapper.standard
    var token: String? {
        get{
            key.string(forKey: "token")
        }
        set{
            if let token = newValue {
                key.set(token, forKey: "token")
            }
        }
    }
}
