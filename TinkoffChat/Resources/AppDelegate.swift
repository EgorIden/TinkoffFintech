//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Egor on 14/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //Change to false to stop loggign
    var logFlag = false
    
    //Method called when the launch process is initiated
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        //print("Application moved from <Not running> to <Inactive>: <\(#function)>")
        printLogsWith(message: "Application moved from <Not running> to <Inactive>: <\(#function)>", flag: logFlag)
        return true
    }

    //Method called when the launch process is nearly complete
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        printLogsWith(message: "Application launching and still <Inactive>: <\(#function)>", flag: logFlag)
        FirebaseApp.configure()
        self.setCoreData()
        return true
    }

    //App has become active
    func applicationDidBecomeActive(_ application: UIApplication) {
        printLogsWith(message: "Application moved from <Inactive> to <Active>: <\(#function)>", flag: logFlag)
    }

    //Method is called when the app change state from active state to inactive state
    func applicationWillResignActive(_ application: UIApplication) {
        printLogsWith(message: "Application moved from <Active> to <Inactive>: <\(#function)>", flag: logFlag)
    }

    //Method is called when the app enters the background
    //In this method Xcode may cause error "Can't end BackgroundTask"
    func applicationDidEnterBackground(_ application: UIApplication) {
        printLogsWith(message: "Application moved from <Inactive> to <Background>: <\(#function)>", flag: logFlag)
    }

    //App goes into the foreground from background
    func applicationWillEnterForeground(_ application: UIApplication) {
        printLogsWith(message: "Application moved from <Background> to <Inactive>: <\(#function)>", flag: logFlag)
    }

    //Method is called when the application is terminated
    //Not called when app is not main and closed from background and
    //Message from debugger: Terminated due to signal 9
    func applicationWillTerminate(_ application: UIApplication) {
        printLogsWith(message: "Application moved from <Background/Suspended> to <Not Running>: <\(#function)>", flag: logFlag)
    }

    //Print logs
    func printLogsWith(message: String, flag: Bool) {
        guard flag else {return}
        print(message)
    }
    
    func setCoreData(){
        CoreDataManager.shared.enableObservers()
        CoreDataManager.shared.didUpdateDatabase = { dbStack in
            dbStack.bdStatistic()
        }
    }
}
