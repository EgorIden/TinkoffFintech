//
//  ThemeDelegate.swift
//  TinkoffChat
//
//  Created by Egor on 06/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

protocol ThemePickerDelegate: AnyObject {
    func chosenTheme(_ bgColor: UIColor)
}
