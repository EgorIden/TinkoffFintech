//
//  TinkoffChatTests.swift
//  TinkoffChatTests
//
//  Created by Egor on 01/12/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import XCTest
@testable import TinkoffChat
class TinkoffChatTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLService() {
        let expectedDataCount = 2
        let requestMock = URLRequestSenderMock()
        let urlService = URLService(requestSender: requestMock)
        //test
        urlService.loadURL { (image, error) in
            if let urlArr = image {
                XCTAssertEqual(urlArr.count, expectedDataCount)
            } else if let error = error {
                XCTAssertEqual(error, "Some error")
            }
        }
        XCTAssertEqual(requestMock.callsCount, 1)
    }
    func testImageService() {
        let expectedImg = UIImage(named: "emblem")
        let requestMock = ImageRequestSenderMock()
        let imgService = ImageService(requestSender: requestMock)
        imgService.loadImage(imageURL: "someURL") { (image, error) in
            if image != nil {
                XCTAssertEqual(image, expectedImg)
            } else if let error = error {
                XCTAssertEqual(error, "No image")
            }
        }
        XCTAssertEqual(requestMock.callsCount, 1)
    }
}
