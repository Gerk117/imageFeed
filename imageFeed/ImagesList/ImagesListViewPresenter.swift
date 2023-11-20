//
//  ImagesListViewPresenter.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//

import Foundation


public protocol ImagesListViewPresenterProtocol {
    var viewController : ImageListViewControllerProtocol? {get set}
    func didSelectImage(at index: IndexPath)
}

class ImagesListPresenter: ImagesListViewPresenterProtocol {
    var viewController: ImageListViewControllerProtocol?
    
    init(viewController: ImageListViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func didSelectImage(at index: IndexPath) {
        viewController?.showSelectedImage(at: index)
    }
}
