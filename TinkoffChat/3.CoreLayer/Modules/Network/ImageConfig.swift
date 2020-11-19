//
//  ImageConfig.swift
//  TinkoffChat
//
//  Created by Egor on 19/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
struct ImageConfig {
    static func imageConfig() -> RequestConfig {
        let request = ImageRequest(apiKey: "19183254-d6e54152d50a71dd67aa14075")
        return RequestConfig(request: request, parser: ImageParser())
    }
}
