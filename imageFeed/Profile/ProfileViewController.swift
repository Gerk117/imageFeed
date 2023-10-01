//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 24.09.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let avatarImageView: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "avatar")
        image.layer.cornerRadius = 35
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    private let nameLabel: UILabel = {
        var label = UILabel()
        label.text = "Migel Ohara"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    private let loginNameLabel: UILabel = {
        var label = UILabel()
        label.text = "SpiderMan_2099"
        label.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    private let descriptionLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "i respect every Spiderman "
        return label
    }()
    
    private let logoutButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    private func didTapLogoutButton() {
    }
    
    private func setupScreen(){
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
            // Здравствуйте! хотел спросить а почему иногда происходит так, что view уходит в другую строну при присвоении положительного числа как в строчке ниже. написал там просто 16 а кнопка ушла вправо. с тем же сталкивался при использовании snapkit. Буду очень благодарен если скажите почему так происходит или поделитесь ссылкой на сайт где этот момент раскрывается, а то самостоятельно найти причину пока не удалось, спасибо!
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
