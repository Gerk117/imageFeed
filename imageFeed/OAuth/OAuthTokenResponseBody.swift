//
//  OAuthTokenResponseBody.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 12.10.2023.
//

import Foundation

class OAuthTokenResponseBody : Codable {
    var access_token : String
    var token_type : String
    var scope : String
    var created_at : Int
}


