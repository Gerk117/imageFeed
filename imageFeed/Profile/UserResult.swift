//
//  File.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 01.11.2023.
//

import Foundation
struct UserResult: Codable {
    var profileImage: Size
}
struct Size: Codable {
    var small: String
}
