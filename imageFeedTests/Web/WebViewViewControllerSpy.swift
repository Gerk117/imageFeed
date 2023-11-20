//
//  WebViewViewControllerSpy.swift
//  imageFeedTests
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//

import imageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: imageFeed.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
