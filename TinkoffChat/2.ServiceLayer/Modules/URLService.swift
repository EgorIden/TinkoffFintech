//
//  URLService.swift
//  TinkoffChat
//
//  Created by Egor on 23/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
protocol IURLService {
    func loadURL(completionHandler: @escaping([Image]?, String?) -> Void)
}
class URLService: IURLService {
    let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    func loadURL(completionHandler: @escaping ([Image]?, String?) -> Void) {
        let config = RequestsFactory.URLRequests.urlConfig()
        requestSender.send(requestConfig: config) { (result: Result<[Image]>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
}
