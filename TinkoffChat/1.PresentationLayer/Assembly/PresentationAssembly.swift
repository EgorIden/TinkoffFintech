//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Egor on 12/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
    func conversationsListViewController() -> ConversationsListViewController
    func сonversationViewController() -> ConversationViewController
    func navigationController() -> UINavigationController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServiceAssembly
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    func navigationController() -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: conversationsListViewController())
        return navigationVC
    }
    func conversationsListViewController() -> ConversationsListViewController {
        let model = ConversationsListModel(firebaseService: serviceAssembly.firebaseService,
                                           coreDataService: serviceAssembly.coreDataService)
        let storyBoard: UIStoryboard = UIStoryboard(name: "ConversationsList", bundle: nil)
        guard let conversationsVC = storyBoard.instantiateViewController(withIdentifier: "ConversationsList")
                                    as? ConversationsListViewController else { return ConversationsListViewController()}
        conversationsVC.presentationAssembly = self
        conversationsVC.model = model
        return conversationsVC
    }
    func сonversationViewController() -> ConversationViewController {
        let model = ConversationListModel(firebaseService: serviceAssembly.firebaseService,
                                           coreDataService: serviceAssembly.coreDataService)
        let сonversationVC = ConversationViewController()
        сonversationVC.presentationAssembly = self
        сonversationVC.model = model
        return сonversationVC
    }
}
