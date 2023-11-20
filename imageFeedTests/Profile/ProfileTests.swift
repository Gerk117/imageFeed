//
//  File.swift
//  imageFeedTests
//
//  Created by Георгий Ксенодохов on 20.11.2023.
//

import XCTest
import SwiftKeychainWrapper
@testable import imageFeed

class ProfileTests: XCTestCase {
    
    var presenter = ProfilePresenterSpy()
    var viewMock = ProfileViewSpy()
    
    override func setUp() {
        super.setUp()
        presenter.view = viewMock
    }
    
    func testToken() {
        var token : String? = nil
        XCTAssertEqual(KeychainWrapper.standard.string(forKey: "token"),token)
    }
    
    func testDidTapLogoutButton() {
        presenter.exit()
        XCTAssertTrue(presenter.exitProfile)
    }
}
