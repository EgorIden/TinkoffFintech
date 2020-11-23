//
//  URLRequest.swift
//  TinkoffChat
//
//  Created by Egor on 22/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
class URLsRequest: IRequest {
    private var baseUrl: String =  "https://pixabay.com/api/"
    private var query: String = "yellow+flowers"
    private var type: String = "photo"
    private let apiKey: String
    private var perPage: Int = 12
    private var getParameters: [String: Any] {
        return ["key": apiKey, "q": query,
                "image_type": type, "per_page": perPage]
    }
    private var urlString: String {
        let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        print("base url->"+baseUrl + "?" + getParams)
        return baseUrl + "?" + getParams
    }
    // MARK: - IRequest
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    // MARK: - Initialization
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
