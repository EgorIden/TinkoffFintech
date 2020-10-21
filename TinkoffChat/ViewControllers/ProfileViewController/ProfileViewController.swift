//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Egor on 14/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //UI
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var profileUserNameField: UITextField!
    @IBOutlet weak var profileUresInfo: UILabel!
    @IBOutlet weak var profileUserInfoField: UITextView!
    @IBOutlet weak var gcdBtn: UIButton!
    @IBOutlet weak var operationBtn: UIButton!
    @IBOutlet weak var editPhotoBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    private var flagName: Bool = false
    private var flagInfo: Bool = false
    private var flagImg: Bool = false

    private let imagePicker = UIImagePickerController()
    private let gcd = GCDDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        profileUserInfoField.delegate = self
        self.setDefaultMode()

        self.gcd.uploadData { user in
            if let user = user {
                self.profileUserName.text = user.name
                self.profileUresInfo.text = user.info
                self.profileImage.image = user.img
                //self.setDefaultMode()
            } else {
                self.retryAlert()
            }
        }

    }

    private func setNavgationButtons() {
        let closeBtn: UIBarButtonItem = {
            let btn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeBtnTapped))
            return btn
        }()
        let editBtn: UIBarButtonItem = {
            let btn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBtnTapped))
            return btn
        }()

        self.navigationItem.leftBarButtonItem = closeBtn
        self.navigationItem.rightBarButtonItem = editBtn
    }

    //Mode
    private func setDefaultMode() {
        self.title = "My profile"
        self.profileImage.layer.cornerRadius = profileImage.bounds.width/2
        //self.profileImage.image = UIImage(named: "photo")

        setNavgationButtons()
        self.profileUserName.isHidden = false
        self.profileUresInfo.isHidden = false
        self.profileUserNameField.isHidden = true
        self.profileUserInfoField.isHidden = true
        self.gcdBtn.isUserInteractionEnabled = false
        self.operationBtn.isUserInteractionEnabled = false
        self.editPhotoBtn.isUserInteractionEnabled = false
        self.indicator.isHidden = true

        self.gcdBtn.layer.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9176470588, blue: 0.9647058824, alpha: 1)
        self.operationBtn.layer.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9176470588, blue: 0.9647058824, alpha: 1)
    }

    //Buttons
    @objc private func editBtnTapped() {
        self.profileImage.image = UIImage(named: "Profile")

        self.profileUserName.isHidden = true
        self.profileUresInfo.isHidden = true
        self.profileUserNameField.isHidden = false
        self.profileUserInfoField.isHidden = false
        self.editPhotoBtn.isUserInteractionEnabled = true

        self.profileUserNameField.text = self.profileUserName.text
        self.profileUserInfoField.text = self.profileUresInfo.text

        self.profileUserNameField.addTarget(self, action: #selector(nameDidChanged), for: .editingChanged)
    }

    @objc private func closeBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func editPhotoBtn(_ sender: Any) {
        self.presentActionSheet()
    }

    @IBAction func gcdBtnTapped(_ sender: Any) {

        var nameData = ""
        var infoData = ""
        var imgData = profileImage.image

        if flagName {
            nameData = profileUserNameField.text ?? "userName"
            print("name if")
        } else {
            nameData = profileUserName.text ?? "userName"
            print("name else")
        }

        if flagInfo {
            infoData = profileUserInfoField.text ?? "userInfo"
            print("info if")
        } else {
            infoData = profileUresInfo.text ?? "userInfo"
            print("info else")
        }

        if flagImg {
            imgData = profileImage.image
            print("img if")
        }

        let user = UserProfile(name: nameData, info: infoData, img: imgData)

        gcd.writeData(dataToSave: user) { [weak self] result in
            if result {
                self?.indicator.isHidden = false
                self?.indicator.startAnimating()

                self?.gcd.uploadData(completion: { user in
                    if let user = user {
                        self?.profileUserName.text = user.name
                        self?.profileUresInfo.text = user.info
                        self?.indicator.stopAnimating()
                        self?.succesAlert()
                        self?.setDefaultMode()
                    } else {
                        DispatchQueue.main.async {
                            self?.retryAlert()
                        }
                    }
                })
                print("succes")
            } else {
                DispatchQueue.main.async {
                    self?.retryAlert()
                }
                print("no secces")
            }
        }
    }

    @IBAction func operationBtnTapped(_ sender: Any) {

    }

    //Changing flags
    @objc private func nameDidChanged() {
        self.gcdBtn.isUserInteractionEnabled = true
        self.gcdBtn.layer.backgroundColor = #colorLiteral(red: 0.5802721635, green: 0.7790466857, blue: 0.9647058824, alpha: 1)
        self.operationBtn.isUserInteractionEnabled = true
        self.operationBtn.layer.backgroundColor = #colorLiteral(red: 0.5802721635, green: 0.7790466857, blue: 0.9647058824, alpha: 1)
        self.flagName = true
    }

    private func infoDidChanged() {
        self.gcdBtn.isUserInteractionEnabled = true
        self.gcdBtn.layer.backgroundColor = #colorLiteral(red: 0.5802721635, green: 0.7790466857, blue: 0.9647058824, alpha: 1)
        self.operationBtn.isUserInteractionEnabled = true
        self.operationBtn.layer.backgroundColor = #colorLiteral(red: 0.5802721635, green: 0.7790466857, blue: 0.9647058824, alpha: 1)
        self.flagInfo = true
    }

    //Action sheet
    private func presentActionSheet() {

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

    private func presentPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          self.imagePicker.sourceType = .camera
          self.imagePicker.allowsEditing = true
          self.present(imagePicker, animated: true, completion: nil)
        } else {
          let alert = UIAlertController(title: "Something wrong",
                                        message: "Your camera is unavailable",
                                        preferredStyle: .alert)

          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
    }

    private func presentLibraryPicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
          self.imagePicker.sourceType = .photoLibrary
          self.imagePicker.allowsEditing = true
          self.present(imagePicker, animated: true, completion: nil)
        } else {
          let alert = UIAlertController(title: "Something wrong",
                                        message: "Your library is empty",
                                        preferredStyle: .alert)

          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
    }

    //Alerts
    private func succesAlert() {
        let alert = UIAlertController(title: "Данные сохранены",
                                      message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (_: UIAlertAction) in
            self.setDefaultMode()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    private func retryAlert() {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Не удалось сохранить данные",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default,
                                      handler: {[weak self] (_: UIAlertAction) in
            guard let slf = self else {return}
            slf.gcdBtnTapped(slf)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.profileImage.image = selectedImage
        flagImg = true
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        infoDidChanged()
    }
}
