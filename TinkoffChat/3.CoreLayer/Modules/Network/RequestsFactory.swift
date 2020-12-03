//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Egor on 22/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
struct RequestsFactory {
    struct URLRequests {
        static func urlConfig() -> RequestConfig<URLParser> {
            let request = URLsRequest(apiKey: "19183254-d6e54152d50a71dd67aa14075")
            return RequestConfig<URLParser>(request: request, parser: URLParser())
        }
    }
    struct ImageRequests {
        static func imageConfig(imageURL: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(imageURL: imageURL)
            return RequestConfig<ImageParser>(request: request, parser: ImageParser())
        }
    }
}
