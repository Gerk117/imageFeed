//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 24.09.2023.
//

import UIKit
import NotificationCenter
import Kingfisher

public protocol ProfileViewControllerProtocol {
    var presenter : ProfileViewPresenterProtocol? { get set }
    func didTapLogoutButton()
}

final class ProfileViewController: UIViewController,ProfileViewControllerProtocol {
    var tokenStorage: OAuth2TokenStorage = OAuth2TokenStorage.shared
    var profileService: ProfileService = ProfileService.shared
    var profileImageService: ProfileImageService = ProfileImageService.shared
    var presenter: ProfileViewPresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private lazy var avatarImageView: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "avatar")
        image.layer.cornerRadius = 35
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "Migel Ohara"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    private lazy var loginNameLabel: UILabel = {
        var label = UILabel()
        label.text = "SpiderMan_2099"
        label.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "i respect every Spiderman"
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        var button = UIButton()
        button.accessibilityIdentifier = "logout button"
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.addTarget(self, action: #selector(showLogoutAlert), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfileViewPresenter(view: self)
        setupScreen()
        updateProfileDetails(profile: profileService.profile)
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar(avatarUrl:profileImageService.avatarURL)
            }
        self.updateAvatar(avatarUrl: profileImageService.avatarURL)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileDetails(profile: profileService.profile)
    }
    @objc private func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены что хотите выйти?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: {_ in
            self.didTapLogoutButton()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    func updateAvatar(avatarUrl: String?) {
        guard let profileImageURL = avatarUrl,
         let url = URL(string: profileImageURL)
        else { return }
        avatarImageView.kf.setImage(with: url)
    }
    
    
    func updateProfileDetails(profile: Profile?) {
        self.nameLabel.text = profile?.name
        self.loginNameLabel.text = profile?.loginName
        self.descriptionLabel.text = profile?.bio
    }
    
    
    func didTapLogoutButton() {
        presenter?.exit()
    }
    
    
    private func setupScreen(){
        view.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        [avatarImageView,
         nameLabel,
         loginNameLabel,
         descriptionLabel,
         logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.trailingAnchor.constraint(lessThanOrEqualTo: logoutButton.leadingAnchor, constant: 0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8)
        ])
        
    }
}
