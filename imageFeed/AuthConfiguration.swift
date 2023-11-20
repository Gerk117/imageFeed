//
//  Constants.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 09.10.2023.
//

import Foundation


let AccessKey = "3mjeZWAt5eVFvbRP06w67IS7r0IddxNsaWOkzpQ0HSY"
let SecretKey = "REJzbqVDMt0kiYI9aDM_Wd7EXpND0B3WcvVKEtdbmHU"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

struct AuthConfiguration {
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: AccessKey,
                                     secretKey: SecretKey,
                                     redirectURI: RedirectURI,
                                     accessScope: AccessScope,
                                     defaultBaseURL: DefaultBaseURL)
        }
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
    }
}
