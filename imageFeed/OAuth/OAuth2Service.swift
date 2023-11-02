//
//  OAuth2Service.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 12.10.2023.
//

import Foundation

class OAuth2Service {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = makeRequest(code: code)
        // понимаю что наверное очень странный вопрос, но почему нельзя написать так : result:Result<OAuthTokenResponseBody,Error>, тоесть без скобок
        let task = urlSession.objectTask(for: request) {[weak self] (result:Result<OAuthTokenResponseBody,Error>) in
            guard let self else {return}
            switch result {
            case .success(let body):
                DispatchQueue.main.async{
                completion(.success(body.accessToken))
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
        private func makeRequest(code: String) -> URLRequest {
            var urlComponents = URLComponents(string:  "https://unsplash.com/oauth/token")!
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: AuthorisationConsts.accessKey),
                URLQueryItem(name: "client_secret", value: AuthorisationConsts.secretKey),
                URLQueryItem(name: "redirect_uri", value: AuthorisationConsts.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
            let url : URL! = urlComponents.url
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            return request
        }
    }


extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let data else {return}
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try? decoder.decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(.success(result!))
            }
        })
        return task
    }
}
