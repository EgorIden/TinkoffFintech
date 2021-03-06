//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Egor on 11/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
protocol IServiceAssembly {
    var firebaseService: IFirebaseService { get }
    var gcdService: GCDDataManager { get }
    var coreDataService: ICoreDataService { get }
}
class ServiceAssembly: IServiceAssembly {
    private let coreAssembly: ICoreAssembly
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var firebaseService: IFirebaseService = FirebaseManager(coreDataService: coreDataService)
    lazy var gcdService: GCDDataManager = GCDDataManager()
    lazy var coreDataService: ICoreDataService = CoreDataManager(coreData: coreAssembly.coreDataStack)
    
}
