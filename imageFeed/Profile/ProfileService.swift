//
//  ProfileService.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 31.10.2023.
//

import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    private init(){}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile?, Error>) -> Void) {
        assert(Thread.isMainThread)
        var request = URLRequest(url: URL(string:"https://api.unsplash.com/me")!)
        request.allHTTPHeaderFields = ["Authorization":"Bearer \(token)"]
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let session = urlSession
        let task = session.objectTask(for: request) {[weak self]  (result:Result<ProfileResult,Error>) in
            guard let self else {return}
            switch result {
            case .success(let result):
                var profile = Profile(username: result.username,
                                      name: result.firstName + " " + (result.lastName ?? ""),
                                      bio: result.bio ?? "")
                profile.loginName += result.username
                self.profile = profile
                DispatchQueue.main.async {
                    completion(.success(profile))
                }
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
