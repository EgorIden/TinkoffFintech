//
//  ConfigurableView.swift
//  TinkoffChat
//
//  Created by Egor on 30/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigureationModel
    func configure(with model: ConfigureationModel)
}
