//
//  ImageService.swift
//  TinkoffChat
//
//  Created by Egor on 23/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
protocol IImageService {
    func loadImage(imageURL: String, completionHandler: @escaping(UIImage?, String?) -> Void)
}
class ImageService: IImageService {
    let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    func loadImage(imageURL: String, completionHandler: @escaping(UIImage?, String?) -> Void) {
        let config = RequestsFactory.ImageRequests.imageConfig(imageURL: imageURL)
        requestSender.send(requestConfig: config) { (result: Result<UIImage>) in
            switch result {
            case .success(let image):
                completionHandler(image, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
}
