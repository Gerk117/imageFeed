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
        guard let request = makeRequest(code: code) else {return}
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
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    private func makeRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string:  "https://unsplash.com/oauth/token") else {return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
            URLQueryItem(name: "client_secret", value: AuthConfiguration.standard.secretKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
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
            let httpResponse = HTTPURLResponse().statusCode
            if 200..<300 ~= httpResponse  {
                guard let data else {return}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let result = try? decoder.decode(T.self, from: data){
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                }
            } else {
                print(httpResponse.description)
            }
            if let error {
                completion(.failure(error))
                return
            }
        })
        return task
    }
}
