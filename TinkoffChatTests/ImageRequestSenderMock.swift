//
//  ImageRequestSender.swift
//  TinkoffChatTests
//
//  Created by Egor on 02/12/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
@testable import TinkoffChat
class ImageRequestSenderMock: IRequestSender {
    var callsCount = 0
    func send<Parser>(requestConfig config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser : IParser {
        self.callsCount += 1
        let mockImage = (UIImage(named: "emblem") as? Parser.Model)!
        
        //Comment one from two
        //succes result
        //completionHandler(Result.success(mockImage))

        //fail result
        completionHandler(Result.error("No image"))
    }
}
