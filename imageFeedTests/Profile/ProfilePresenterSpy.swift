//
//  PresenterMock.swift
//  imageFeedTests
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//

import Foundation
import imageFeed


class ProfilePresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var exitProfile = false
    

    func exit() {
        exitProfile = true
    }
}
