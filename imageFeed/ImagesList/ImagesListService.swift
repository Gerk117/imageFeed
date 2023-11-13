//
//  ImagesListService.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 13.11.2023.
//

import UIKit

class ImagesListService {
    private var lastLoadedPage : Int?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    
     func fetchPhotosNextPage() {
        guard task == nil else {return}
        var request = URLRequest(url: URL(string:"https://api.unsplash.com/photos?page=1..<10_000&per_page=10")!)
         request.allHTTPHeaderFields = ["Authorization":"Bearer \(OAuth2TokenStorage().token!)"]
        let session = urlSession
        let task = session.objectTask(for: request) {[weak self] (result:Result<PhotoResult,Error>) in
            guard let self else {return}
            switch result {
            case .success(let result):
                print(result.description)
                let photo = Photo(id: result.id,
                                   size: CGSize(width: result.width, height: result.height),
                                   createdAt: nil,
                                   welcomeDescription: result.description,
                                   thumbImageURL: result.urls.thumb,
                                   largeImageURL: result.urls.full,
                                   isLiked: result.likedByUser)
                photos.append(photo)
            case .failure(let error):
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
}
