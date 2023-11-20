//
//  ImageListTest.swift
//  imageFeedTests
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//


import XCTest
@testable import imageFeed

class ImageListTest: XCTestCase {
    var presenter: ImageListPresenterSpy!
    var viewController: ImageListViewSpy!
    var imageIndexPath : IndexPath = [0]
    override func setUp() {
        super.setUp()
        presenter = ImageListPresenterSpy()
        viewController = ImageListViewSpy()
        presenter.viewController = viewController
        viewController.presenter = presenter
    }

    override func tearDown() {
        presenter = nil
        viewController = nil
        super.tearDown()
    }

    func testDidSelectImage() {
        presenter.didSelectImage(at: imageIndexPath)
        XCTAssertTrue(presenter.didSelected)
    }

    func testShowSelectedImage() {
        viewController.showSelectedImage(at: imageIndexPath)
        XCTAssertTrue(viewController.showImage)
    }
}
