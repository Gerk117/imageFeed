//
//  ProfileViewMock.swift
//  imageFeedTests
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//

import Foundation
import imageFeed


class ProfileViewSpy
: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    var didTapLogoutButtonCalled = false

    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
}



