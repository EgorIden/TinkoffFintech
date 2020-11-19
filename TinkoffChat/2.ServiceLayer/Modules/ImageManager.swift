//
//  ImageService.swift
//  TinkoffChat
//
//  Created by Egor on 19/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
protocol IImageService {
    func getImagesURLs(completionHandler: @escaping ([Image]?, String?) -> Void)
    func getImages(imageURL: String, completionHandler: @escaping (UIImage?, String?) -> Void)
}
class ImageManager: IImageService {
    let requestSender: IRequestSender
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    func getImagesURLs(completionHandler: @escaping ([Image]?, String?) -> Void) {
        loadImagesURLs(completionHandler: completionHandler)
    }
    func getImages(imageURL: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        loadImages(imageURL: imageURL, completionHandler: completionHandler)
    }
    func loadImagesURLs(completionHandler: @escaping ([Image]?, String?) -> Void) {
        let requestConfig = ImageConfig.imageConfig()
        requestSender.send(requestConfig: requestConfig) { (result: Result<[Image]>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
                print("images count in load -> \(images.count)")
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    func loadImages(imageURL: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        let requestConfig = ImageConfig.imageConfig()
//        requestSender.send(requestConfig: requestConfig) { (result: Result<[Image]>) in
//            switch result {
//            case .success(let images):
//                completionHandler(images, nil)
//                print("images count in load -> \(images.count)")
//            case .error(let error):
//                completionHandler(nil, error)
//            }
//        }
    }
}
