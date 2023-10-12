//
//  OAuth2Service.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 12.10.2023.
//

import Foundation

class OAuth2Service {
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        var urlComponents = URLComponents(string:  "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthorisationConsts.accessKey),
            URLQueryItem(name: "client_secret", value: AuthorisationConsts.secretKey),
            URLQueryItem(name: "redirect_uri", value: AuthorisationConsts.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url
        var uRLrequest = URLRequest(url:url!)
        uRLrequest.httpMethod = "Post"
        URLSession.shared.dataTask(with: uRLrequest) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299 :
                    guard let data else {return}
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try? decoder.decode(OAuthTokenResponseBody.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result?.accessToken ?? ""))
                    }
                default :
                    if let error {completion(.failure(error))}
                }
            }
        }.resume()
    }
    
}
