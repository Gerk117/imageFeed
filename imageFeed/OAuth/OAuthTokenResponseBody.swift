//
//  OAuthTokenResponseBody.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 12.10.2023.
//

import Foundation

struct OAuthTokenResponseBody : Codable {
    var accessToken : String
    var tokenType : String
    var scope : String
    var createdAt : Int
}
