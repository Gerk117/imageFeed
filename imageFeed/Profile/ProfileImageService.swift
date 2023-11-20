//
//  ProfileImageService.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 01.11.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    private init(){}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard self.task == nil else {return}
        var request = URLRequest(url: URL(string:"https://api.unsplash.com/users/\(username)")!)
        request.allHTTPHeaderFields = ["Authorization":"Bearer \(OAuth2TokenStorage.shared.token!)"]
        let session = urlSession
        let task = session.objectTask(for: request) {[weak self] (result:Result<UserResult,Error>) in
            guard let self else {return}
            switch result {
            case .success(let user):
                self.avatarURL = user.profileImage.medium
                DispatchQueue.main.async {
                    completion(.success(user.profileImage.medium))
                }
                NotificationCenter.default.post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": user.profileImage.medium])
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            self.task = nil
        }
        self.task = task
        task.resume()
        
    }
}
