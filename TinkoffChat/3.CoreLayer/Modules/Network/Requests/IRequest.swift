//
//  IRequest.swift
//  TinkoffChat
//
//  Created by Egor on 22/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
protocol IRequest {
    var urlRequest: URLRequest? { get }
}