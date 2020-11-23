//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by Egor on 22/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
class ImageRequest: IRequest {
    private var imageURL: String
    private var urlString: String {
        return imageURL
    }
    // MARK: - IRequest
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    // MARK: - Initialization
    init(imageURL: String) {
        self.imageURL = imageURL
    }
}
