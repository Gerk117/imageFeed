//
//  File.swift
//  imageFeedTests
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//

import Foundation
import imageFeed

class ImageListViewSpy : ImageListViewControllerProtocol {
    var presenter: imageFeed.ImagesListViewPresenterProtocol?
    var showImage = false
    
    func showSelectedImage(at: IndexPath) {
        showImage = !showImage
    }
}
