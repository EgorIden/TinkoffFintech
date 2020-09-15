//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Egor on 14/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Change to false to stop loggign
    var logFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printLogsWith(message: "*Method: \(#function) was called", flag: logFlag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        printLogsWith(message: "*Method: \(#function) was called", flag: logFlag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLogsWith(message: "*Method: \(#function) was called", flag: logFlag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLogsWith(message: "*Method: \(#function) was called", flag: logFlag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        printLogsWith(message: "*Method: \(#function) was called", flag: logFlag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        printLogsWith(message: "*Method: \(#function) was called", flag: logFlag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        printLogsWith(message: "*Method: \(#function) was called", flag: logFlag)
    }
    
    //Print logs
    func printLogsWith(message: String, flag: Bool){
        guard flag else {return}
        print(message)
    }
    
}

