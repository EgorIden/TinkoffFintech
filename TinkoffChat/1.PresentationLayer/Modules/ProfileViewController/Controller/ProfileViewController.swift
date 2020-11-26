//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Egor on 14/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: Setup UI
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var profileUserNameField: UITextField!
    @IBOutlet weak var profileUresInfo: UILabel!
    @IBOutlet weak var profileUserInfoField: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var editPhotoBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var flagName: Bool = false
        private var flagInfo: Bool = false
        private var flagImg: Bool = false
        private var animationTap: Bool = true
        
        private let imagePicker = UIImagePickerController()
        var model: IProfileModel?
        var presentationAssembly: IPresentationAssembly?
        private var emblem: EmblemAnimation?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.imagePicker.delegate = self
            self.profileUserInfoField.delegate = self
            self.setDefaultMode()
            self.addAnimation()
            self.model?.uploadData(completion: { user in
                if let user = user {
                    self.profileUserName.text = user.name
                    self.profileUresInfo.text = user.info
                    self.mainImage.image = user.img
                }
            })
        }
        private func addAnimation() {
            self.emblem = EmblemAnimation(view: self.view)
        }
        private func setGestureForImage() {
            let mainGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTap))
            let secondGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTap))
            self.mainImage.layer.cornerRadius = mainImage.bounds.width/2
            self.mainImage.addGestureRecognizer(mainGesture)
            self.secondImage.layer.cornerRadius = secondImage.bounds.width/2
            self.secondImage.addGestureRecognizer(secondGesture)
        }
        // Bar buttons
        private func setBarButtons() {
            let closeBtn: UIBarButtonItem = {
                let btn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeBtnTap))
                return btn
            }()
    //        let editBtn: UIBarButtonItem = {
    //            let btn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBtnTapped))
    //            return btn
    //        }()
           // self.navigationItem.rightBarButtonItem = editBtn
            self.navigationItem.leftBarButtonItem = closeBtn
        }
        // Mode
        private func setDefaultMode() {
            self.title = "My profile"
            self.mainImage.isHidden = false
            self.secondImage.isHidden = true
            self.profileUserName.isHidden = false
            self.profileUresInfo.isHidden = false
            self.profileUserNameField.isHidden = true
            self.profileUserInfoField.isHidden = true
            self.saveBtn.isUserInteractionEnabled = false
            self.editPhotoBtn.isUserInteractionEnabled = false
            self.indicator.isHidden = true
            self.saveBtn.layer.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.9176470588, blue: 0.9647058824, alpha: 1)
            setBarButtons()
            setGestureForImage()
        }
        // Edit tap
        @objc private func editBtnTap(isEdit: Bool) {
            if isEdit {
                self.mainImage.isHidden = true
                self.secondImage.isHidden = false
                self.profileUserName.isHidden = true
                self.profileUresInfo.isHidden = true
                self.profileUserNameField.isHidden = false
                self.profileUserInfoField.isHidden = false
                self.profileUserNameField.text = self.profileUserName.text
                self.profileUserInfoField.text = self.profileUresInfo.text
                self.profileUserNameField.addTarget(self, action: #selector(nameDidChanged), for: .editingChanged)
                self.editPhotoBtn.isUserInteractionEnabled = true
            } else {
                self.setDefaultMode()
            }
        }
        // Img Tap
        @objc private func avatarTap() {
            self.presentActionSheet()
        }
        // Close Tap
        @objc private func closeBtnTap() {
            self.dismiss(animated: true, completion: nil)
        }
        // Edit btn
        @IBAction func editBtn(_ sender: Any) {
            if animationTap {
                self.editBtnAnimation(tap: animationTap)
                self.editBtnTap(isEdit: animationTap)
                animationTap = !animationTap
            } else {
                self.editBtnAnimation(tap: animationTap)
                self.editBtnTap(isEdit: animationTap)
                animationTap = !animationTap
            }
        }
        // Edit photo btn
        @IBAction func editPhotoBtn(_ sender: Any) {
            self.presentActionSheet()
        }
        // Save btn
        @IBAction func saveBtn(_ sender: Any) {

            var nameData = ""
            var infoData = ""
            var imgData = mainImage.image

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
                imgData = secondImage.image
                print("img if")
            }

            let user = UserProfile(name: nameData, info: infoData, img: imgData)
            self.model?.writeData(dataToSave: user, completion: { [weak self] result in
                if result {
                    self?.indicator.isHidden = false
                    self?.indicator.startAnimating()
                    self?.model?.uploadData(completion: { user in
                        if let user = user {
                            self?.profileUserName.text = user.name
                            self?.profileUresInfo.text = user.info
                            self?.indicator.stopAnimating()
                            self?.succesAlert()
                        } else {
                            self?.retryAlert()
                        }
                    })
                } else {
                    self?.retryAlert()
                }
            })
        }
        // MARK: Changing flags
        @objc private func nameDidChanged() {
            self.saveBtn.isUserInteractionEnabled = true
            self.saveBtn.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.4588235294, blue: 0.9647058824, alpha: 1)
            self.saveBtn.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.flagName = true
        }

        private func infoDidChanged() {
            self.saveBtn.isUserInteractionEnabled = true
            self.saveBtn.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.4588235294, blue: 0.9647058824, alpha: 1)
            self.saveBtn.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.flagInfo = true
        }
        // MARK: Action sheet
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

            actionSheet.addAction(UIAlertAction(title: "Download",
                                              style: .default,
                                              handler: { [weak self] _ in
                                                  self?.downloadPhoto()
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
        private func downloadPhoto() {
            if let avatarVC = presentationAssembly?.avatarController() {
                avatarVC.imageHandler = { image in
                    self.mainImage.image = image
                    self.secondImage.image = image
                    self.flagImg = true
                }
                let navVC = UINavigationController(rootViewController: avatarVC)
                self.present(navVC, animated: true, completion: nil)
            } else {
              let alert = UIAlertController(title: "Something wrong",
                                            message: "Downloading is unavailable",
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

        //MARK: Alerts
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
                slf.saveBtn(slf)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
            self.secondImage.image = selectedImage
            self.flagImg = true
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
    extension ProfileViewController {
        func editBtnAnimation(tap: Bool) {
            if tap {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0,
                                        options: [.repeat, .autoreverse, .allowUserInteraction, .calculationModeCubicPaced],
                                        animations: {
                                            UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                relativeDuration: 0.5) {
                                                    self.editBtn.transform = CGAffineTransform(translationX: 5, y: 5)
                                            }
                                            UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                               relativeDuration: 0.5) {
                                                                self.editBtn.transform = CGAffineTransform(rotationAngle: .pi/10)
                                            }
                                            UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                               relativeDuration: 1) {
                                                                self.editBtn.transform = CGAffineTransform(translationX: -5, y: -5)
                                            }
                                            UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                               relativeDuration: 1) {
                                                                self.editBtn.transform = CGAffineTransform(rotationAngle: -.pi/10)
                                            }
                                        }, completion: nil)
            } else {
                editBtn.layer.removeAllAnimations()
                editBtn.layoutIfNeeded()
                UIView.animate(withDuration: 0.5) {
                    self.editBtn.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.editBtn.transform = CGAffineTransform(rotationAngle: 0)
                }
            }
        }
    }
