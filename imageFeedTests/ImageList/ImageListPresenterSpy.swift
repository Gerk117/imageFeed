//
//  ImageListPresenterSpy.swift
//  imageFeedTests
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//

import Foundation
import imageFeed

class ImageListPresenterSpy: ImagesListViewPresenterProtocol {
    var viewController: imageFeed.ImageListViewControllerProtocol?
    var didSelected = false
    
    func didSelectImage(at index: IndexPath) {
        didSelected = !didSelected
    }
}

