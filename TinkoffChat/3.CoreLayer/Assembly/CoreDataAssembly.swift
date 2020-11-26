//
//  CoreDataAssembly.swift
//  TinkoffChat
//
//  Created by Egor on 10/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
protocol ICoreAssembly {
    var coreDataStack: CoreDataStack { get }
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var coreDataStack: CoreDataStack = CoreDataStack.shared
    lazy var requestSender: IRequestSender = RequestSender()
}
