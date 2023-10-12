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
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url
        var uRLrequest = URLRequest(url:url!)
        uRLrequest.httpMethod = "Post"
        URLSession.shared.dataTask(with: uRLrequest) { data, _, _ in
            guard let data else {return}
            let response = try? JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
            DispatchQueue.main.async {
                completion(.success(response?.access_token ?? ""))
            }
        }.resume()
    }
    
}
