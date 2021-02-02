//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Egor on 04/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet weak var classicBtn: UIButton!
    @IBOutlet weak var dayBtn: UIButton!
    @IBOutlet weak var nightBtn: UIButton!
    
    @IBOutlet var buttons: [UIButton]!

    @IBOutlet weak var classicLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var nightLbl: UILabel!

    private let defaultColor = #colorLiteral(red: 0.1246537641, green: 0.280626744, blue: 0.4565510154, alpha: 1)
    private let borderColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
    private var prevBtn: UIButton?

    private let classicColor = #colorLiteral(red: 0.7500573993, green: 0.7736744285, blue: 0.7676191926, alpha: 1)
    private let dayColor = #colorLiteral(red: 0.6395892501, green: 0.758245945, blue: 0.7440233827, alpha: 1)
    private let nightColor = #colorLiteral(red: 0.391071409, green: 0.4231441617, blue: 0.6002907753, alpha: 1)

    // Retain cycle возникает при использовании сильных ссылок между объектами
    // Для избежания этого используются специальные ключевые слова - weak, unowned
    // и конструкция [weak self]
    // Это позволяет создавать слабые ссылки на объекты, которую потом удаляет ARC

    var themeHandler: ((UIColor) -> Void)?
    weak var delegate: ThemePickerDelegate?
    private var emblem: EmblemAnimation?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.classicLbl.isUserInteractionEnabled = true
        self.dayLbl.isUserInteractionEnabled = true
        self.nightLbl.isUserInteractionEnabled = true

        let classicGesture = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        let dayGesture = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        let nightGesture = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))

        self.classicLbl.addGestureRecognizer(classicGesture)
        self.dayLbl.addGestureRecognizer(dayGesture)
        self.nightLbl.addGestureRecognizer(nightGesture)
        //self.addAnimatioin()
        //print(classicBtn.currentTitle, dayBtn.currentTitle, nightBtn.currentTitle)
    }
    private func addAnimatioin(){
        self.emblem = EmblemAnimation(view: self.view)
    }
    @IBAction func changeTheme(sender: UIButton) {
        switch sender.tag {
            case 0:
            setClassicTheme()
            case 1:
            setDayTheme()
            case 2:
            setNightTheme()
        default:
            return
        }
    }

    @objc private func setClassicTheme() {
        if buttons[0].isSelected {
            buttons[0].layer.borderWidth = 0
            buttons[0].isSelected = false
            self.view.backgroundColor = defaultColor

            themeHandler?(.white)
            //self.delegate?.chosenTheme(.white)
            self.prevBtn = classicBtn
        } else {
            buttons[0].layer.cornerRadius = 14
            buttons[0].layer.borderWidth = 2
            buttons[0].layer.borderColor = borderColor.cgColor
            buttons[0].isSelected = true
            self.view.backgroundColor = classicColor

            themeHandler?(classicColor)
            //self.delegate?.chosenTheme(classicColor)
            self.prevBtn = classicBtn
        }
    }

    @objc private func setDayTheme() {
        if buttons[1].isSelected {
            buttons[1].layer.borderWidth = 0
            buttons[1].isSelected = false
            self.view.backgroundColor = defaultColor

            themeHandler?(.white)
            //self.delegate?.chosenTheme(.white)
            self.prevBtn = dayBtn
        } else {
            buttons[1].layer.cornerRadius = 14
            buttons[1].layer.borderWidth = 2
            buttons[1].layer.borderColor = borderColor.cgColor
            buttons[1].isSelected = true
            self.view.backgroundColor = dayColor

            themeHandler?(dayColor)
            //self.delegate?.chosenTheme(dayColor)
            self.prevBtn = dayBtn
        }
    }

    @objc private func setNightTheme() {
        if buttons[2].isSelected {
            buttons[2].layer.borderWidth = 0
            buttons[2].isSelected = false
            self.view.backgroundColor = defaultColor

            themeHandler?(.white)
            //self.delegate?.chosenTheme(.white)
            self.prevBtn = nightBtn
        } else {
            buttons[2].layer.cornerRadius = 14
            buttons[2].layer.borderWidth = 2
            buttons[2].layer.borderColor = borderColor.cgColor
            buttons[2].isSelected = true
            self.view.backgroundColor = nightColor

            themeHandler?(nightColor)
            //self.delegate?.chosenTheme(nightColor)
            self.prevBtn = nightBtn
        }
    }

    private func clearBorder(prevButton: UIButton?) {
        guard let prev = prevButton else {return}
        prev.layer.borderWidth = 0
    }

}
