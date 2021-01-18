//
//  RequestSenderMock.swift
//  TinkoffChatTests
//
//  Created by Egor on 02/12/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
@testable import TinkoffChat
class URLRequestSenderMock: IRequestSender {
    var callsCount = 0
    func send<Parser>(requestConfig config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser : IParser {
        let mockData: Parser.Model = ([Image(userImageURL: "someURLImageAddress1"),
                                       Image(userImageURL: "someURLImageAddress2")] as? Parser.Model)!
        self.callsCount += 1
        
        // Comment one from two
        //succes result
        //completionHandler(Result.success(mockData))

        //fail result
        completionHandler(Result.error("Some error"))
    }
}
