//
//  Constants.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 09.10.2023.
//

import Foundation

enum AuthorisationConsts {
    static let accessKey = "3mjeZWAt5eVFvbRP06w67IS7r0IddxNsaWOkzpQ0HSY"
    static let secretKey = "REJzbqVDMt0kiYI9aDM_Wd7EXpND0B3WcvVKEtdbmHU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
}
