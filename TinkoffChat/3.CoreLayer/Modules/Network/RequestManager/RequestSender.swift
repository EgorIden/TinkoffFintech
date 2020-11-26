//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Egor on 22/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
class RequestSender: IRequestSender {
    let session = URLSession.shared
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let slf = self else { return }
            let task = slf.session.dataTask(with: urlRequest) { (data: Data?,
                                                            response: URLResponse?,
                                                            error: Error?) in
                if let error = error {
                    completionHandler(Result.error(error.localizedDescription))
                    print("Error in send -> \(error.localizedDescription)")
                    return
                }
                guard let data = data, let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                        completionHandler(Result.error("received data can't be parsed"))
                        return
                }
                DispatchQueue.main.async {
                    completionHandler(Result.success(parsedModel))
                }
            }
            task.resume()
        }
    }
}
