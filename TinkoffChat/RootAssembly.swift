//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Egor on 12/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
