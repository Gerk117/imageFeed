//
//  SplashViewController.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 12.10.2023.
//

import UIKit


final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private var imageView : UIImageView = {
        var image = UIImageView(image: UIImage(named: "splash_screen_logo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oauth2TokenStorage.token != nil {
            fetchProfile(token: OAuth2TokenStorage().token!)

        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    private func setupScreen(){
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    func presentAuthView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var view = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        view.delegate = self
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage().token = token
                self.fetchProfile(token: token)
                switchToTabBarController()
            case .failure:
                self.showAlert()
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
   
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
            profileService.fetchProfile(token) { result in
                switch result {
                case .success(let profile):
                    self.fetchProfileImageURL(username: profile?.username ?? "")
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    self.showAlert()
                    break
                }
            }
        
        
    }
    
    private func fetchProfileImageURL(username : String) {
        profileImageService.fetchProfileImageURL(username: username) { result in
            switch result {
            case .success(let imageUrl):
                print(imageUrl)
            case .failure(let error):
                self.showAlert()
                break
            }
        }
    }
}

extension UIViewController {
    func showAlert(){
        var alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        self.present(alert, animated: true)
    }
}
