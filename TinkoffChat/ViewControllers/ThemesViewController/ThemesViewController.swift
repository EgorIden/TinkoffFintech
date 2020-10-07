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
    
    @IBOutlet weak var classicLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var nightLbl: UILabel!
    
    private let defaultColor = #colorLiteral(red: 0.1246537641, green: 0.280626744, blue: 0.4565510154, alpha: 1)
    private let borderColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
    
    private let classicColor = #colorLiteral(red: 0.7500573993, green: 0.7736744285, blue: 0.7676191926, alpha: 1)
    private let dayColor = #colorLiteral(red: 0.6395892501, green: 0.758245945, blue: 0.7440233827, alpha: 1)
    private let nightColor = #colorLiteral(red: 0.391071409, green: 0.4231441617, blue: 0.6002907753, alpha: 1)
    
    // Retain cycle возникает при использовании сильных ссылок между объектами
    // Для избежания этого используются специальные ключевые слова - weak, unowned
    // и конструкция [weak self]
    // Это позволяет создавать слабые ссылки на объекты, которую потом удаляет ARC
    
    var themeHandler: ((UIColor)->())?
    weak var delegate: ThemePickerDelegate?
    
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
    }
    
    @IBAction func changeTheme(sender: UIButton) {

        switch sender.currentTitle {
            case "Classic":
            setClassicTheme()
            case "Day":
            setDayTheme()
            case "Night":
            setNightTheme()
        default:
            return
        }
    }
    
    @objc private func setClassicTheme(){
        if classicBtn.isSelected{
            classicBtn.layer.borderWidth = 0
            classicBtn.isSelected = false
            self.view.backgroundColor = defaultColor
            
            themeHandler?(.white)
            //self.delegate?.chosenTheme(.white)
        }else{
            classicBtn.layer.cornerRadius = 14
            classicBtn.layer.borderWidth = 2
            classicBtn.layer.borderColor = borderColor.cgColor
            classicBtn.isSelected = true
            self.view.backgroundColor = classicColor
            
            themeHandler?(classicColor)
            //self.delegate?.chosenTheme(classicColor)
        }
    }
    
    @objc private func setDayTheme(){
        if dayBtn.isSelected{
            dayBtn.layer.borderWidth = 0
            dayBtn.isSelected = false
            self.view.backgroundColor = defaultColor
            
            themeHandler?(.white)
            //self.delegate?.chosenTheme(.white)
        }else{
            dayBtn.layer.cornerRadius = 14
            dayBtn.layer.borderWidth = 2
            dayBtn.layer.borderColor = borderColor.cgColor
            dayBtn.isSelected = true
            self.view.backgroundColor = dayColor
            
            themeHandler?(dayColor)
            //self.delegate?.chosenTheme(dayColor)
        }
    }
    
    @objc private func setNightTheme(){
        if nightBtn.isSelected{
            nightBtn.layer.borderWidth = 0
            nightBtn.isSelected = false
            self.view.backgroundColor = defaultColor
            
            themeHandler?(.white)
            //self.delegate?.chosenTheme(.white)
        }else{
            nightBtn.layer.cornerRadius = 14
            nightBtn.layer.borderWidth = 2
            nightBtn.layer.borderColor = borderColor.cgColor
            nightBtn.isSelected = true
            self.view.backgroundColor = nightColor
            
            themeHandler?(nightColor)
            //self.delegate?.chosenTheme(nightColor)
        }
    }
}
