//
//  ImagesListService.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 13.11.2023.
//

import UIKit

class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let dateForm = ISO8601DateFormatter()
    private (set) var photos: [Photo] = []
    private var nextPage = 0
    private init(){}
    
    func fetchPhotosNextPage(comp : @escaping (Result<[Photo],Error>)->()) {
        assert(Thread.isMainThread)
        guard task == nil else {return}
        nextPage += 1
        var request = URLRequest(url: URL(string:"https://api.unsplash.com/photos?page=\(nextPage)&per_page=10")!)
        request.allHTTPHeaderFields = ["Authorization":"Bearer \(OAuth2TokenStorage.shared.token!)"]
        let session = urlSession
        let task = session.objectTask(for: request) {[weak self] (result:Result<[PhotoResult],Error>) in
            guard let self else {return}
            switch result {
            case .success(let result):
                var photos = [Photo]()
                result.forEach { result in
                    let photo = Photo(id: result.id,
                                      size: CGSize(width: result.width, height: result.height),
                                      createdAt:self.dateForm.date(from: result.createdAt ?? ""),
                                      welcomeDescription: result.description,
                                      thumbImageURL: result.urls.thumb,
                                      largeImageURL: result.urls.full,
                                      isLiked: result.likedByUser)
                    photos.append(photo)
                }
                self.photos += photos
                comp(.success(self.photos))
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": self.photos])
            case .failure(let error):
                DispatchQueue.main.async {
                    comp(.failure(error))
                }
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let index = photos.firstIndex(where: { $0.id == photoId }) else {
            return
        }
        
        let photo = self.photos[index]
        let newPhoto = Photo(
            id: photo.id,
            size: photo.size,
            createdAt: photo.createdAt,
            welcomeDescription: photo.welcomeDescription,
            thumbImageURL: photo.thumbImageURL,
            largeImageURL: photo.largeImageURL,
            isLiked: !isLike
        )
        self.photos[index] = newPhoto
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/\(photoId)/like")!)
        request.allHTTPHeaderFields = ["Authorization":"Bearer \(OAuth2TokenStorage.shared.token!)"]
        request.httpMethod = isLike ? "DELETE" : "POST"
        let task = urlSession.objectTask(for: request) { [weak self] (result:Result<PhotoResult,Error>) in
            guard let self else {return}
            switch result {
            case .success(let result):
                let photo = Photo(id: result.id,
                                  size: CGSize(width: result.width, height: result.height),
                                  createdAt:dateForm.date(from: result.createdAt ?? ""),
                                  welcomeDescription: result.description,
                                  thumbImageURL: result.urls.thumb,
                                  largeImageURL: result.urls.full,
                                  isLiked: result.likedByUser)
                self.photos[index] = photo
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": self.photos as Any]
                )
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        completion(.success(()))
        task.resume()
    }
}
