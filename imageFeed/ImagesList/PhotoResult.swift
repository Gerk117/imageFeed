//
//  PhotoResult.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 13.11.2023.
//

import Foundation

struct PhotoResult : Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height : Int
    let description: String
    let likedByUser: Bool
    let urls : Urls
}

struct Urls : Codable {
    let thumb: String
    let full: String
}
