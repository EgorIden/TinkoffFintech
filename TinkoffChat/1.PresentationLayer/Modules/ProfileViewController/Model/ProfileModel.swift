//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Egor on 23/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
protocol IProfileModel {
    func writeData(dataToSave: UserProfile, completion: @escaping (Bool) -> Void)
    func uploadData(completion: @escaping (UserProfile?) -> Void)
}
class ProfileModel: IProfileModel {
    private let defaultUser: UserProfile = UserProfile(name: "Mr.Orange",
                                                       info: "Начинаюший iOS разработчик",
                                                       imgName: "photo")
    var gcdService: IGCDService

    init(gcdService: IGCDService) {
        self.gcdService = gcdService
    }

    func writeData(dataToSave: UserProfile, completion: @escaping (Bool) -> Void) {
        self.gcdService.writeData(dataToSave: dataToSave) { result in
            completion(result)
        }
    }

    func uploadData(completion: @escaping (UserProfile?) -> Void) {
        self.gcdService.uploadData { user in
            guard let user = user else {return}
            if user.name == "" && user.info == ""{
                DispatchQueue.main.async {
                    completion(self.defaultUser)
                }
            } else {
                DispatchQueue.main.async {
                    completion(user)
                }
            }
        }
    }
}
