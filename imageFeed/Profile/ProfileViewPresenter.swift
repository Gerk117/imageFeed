//
//  File.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//

import Foundation
import UIKit

public protocol ProfileViewPresenterProtocol {
    var view : ProfileViewControllerProtocol? {get set}
    func exit()
}
class ProfileViewPresenter : ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    init(view : ProfileViewControllerProtocol) {
        self.view = view
    }
    
    
    func exit() {
        WebViewViewController.clean()
        OAuth2TokenStorage.shared.token = nil
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let splashView = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "SplashViewController")
        window.rootViewController = splashView
    }
    
}

