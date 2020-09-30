//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Egor on 14/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //Change to false to stop loggign
    var logFlag = true
    
    //UI
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var profileUresInfo: UILabel!
    @IBOutlet weak var saveProfileButton: UIButton!
    
    private let imagePicker = UIImagePickerController()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        //Возникает краш
        //Свойство frame нельзя распечатать, так как вью еще не проинициализирована
        //printLogsWith(message: "\(saveProfileButton.frame)",flag: logFlag )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        profileImage.layer.cornerRadius = profileImage.bounds.width/2
        
        //На данном этапе загружается вью девайса из сториборда
        //но ее размеры не актуальны и будут пересчитаны в дальнейшем
        printLogsWith(message: "\(#function): button frame - \(saveProfileButton.frame)", flag: logFlag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //Здесь вью имеет актуальные размеры девайса симулятора
        //фрейм кнопки расположен в актуальных координатах
        printLogsWith(message: "\(#function): button frame - \(saveProfileButton.frame)", flag: logFlag)
    }
    
    @IBAction func editPhotoButton(_ sender: Any) {
        presentActionSheet()
    }
    
    //Save profile change
    @IBAction func saveProfileButton(_ sender: Any) {
        
    }
    
    private func presentActionSheet(){
        //В консоли может появляться ошибка констрейнов
        //Это баг Xcode
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                          style: .cancel,
                                          handler: nil))

        actionSheet.addAction(UIAlertAction(title: "Take a photo",
                                          style: .default,
                                          handler: { [weak self] _ in
                                              self?.presentPhoto()
          }))

        actionSheet.addAction(UIAlertAction(title: "Choose photo",
                                          style: .default,
                                          handler: { [weak self] _ in
                                              self?.presentLibraryPicker()
          
          }))

        self.present(actionSheet, animated: true)
    }
      
    private func presentPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          self.imagePicker.sourceType = .camera
          self.imagePicker.allowsEditing = true
          self.present(imagePicker, animated: true, completion: nil)
        }else{
          let alert = UIAlertController(title: "Something wrong", message: "Your camera is unavailable", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
    }

    private func presentLibraryPicker(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
          self.imagePicker.sourceType = .photoLibrary
          self.imagePicker.allowsEditing = true
          self.present(imagePicker, animated: true, completion: nil)
        }else{
          let alert = UIAlertController(title: "Something wrong", message: "Your library is empty", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Print logs
    func printLogsWith(message: String, flag: Bool){
        guard flag else {return}
        print(message)
    }
    
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.profileImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

