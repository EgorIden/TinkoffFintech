//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Egor on 19/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
struct RequestConfig {
    let request: IRequest
    let parser: ImageParser
}

enum Result<Model> {
    case success(Model)
    case error(String)
}

protocol IRequestSender {
    func send(requestConfig config: RequestConfig,
              completionHandler: @escaping(Result<ImageParser.Model>) -> Void)
}
class RequestSender: IRequestSender {
    let session = URLSession.shared
    func send(requestConfig config: RequestConfig, completionHandler: @escaping (Result<ImageParser.Model>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            guard let data = data, let parsedModel: ImageParser.Model = config.parser.parse(data: data) else {
                    completionHandler(Result.error("received data can't be parsed"))
                    return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        task.resume()
    }
}
