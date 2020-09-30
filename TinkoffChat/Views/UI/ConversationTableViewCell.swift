//
//  ConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Egor on 30/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    typealias ConfigureationModel = MessageCellModel
    
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leadingingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.messageLabel.text = nil
        self.leadingingConstraint.isActive = false
        self.trailingConstraint.isActive = false
    }
    
}
extension ConversationTableViewCell: ConfigurableView {
    
    func configure(with model: ConfigureationModel) {
        
        let widtConstraint = self.frame.width/4
        
        self.messageBackground.layer.cornerRadius = 16
        self.messageBackground.clipsToBounds = true
        
        self.messageLabel.text = model.text
        
        if model.isOutput{
            self.messageBackground.backgroundColor = UIColor(red: 53/255.0, green: 154/255.0, blue: 255/255, alpha: 1.0)
            self.leadingingConstraint.constant = widtConstraint
        }else{
            self.messageBackground.backgroundColor = UIColor(red: 83/255.0, green: 167/255.0, blue: 93/255, alpha: 1.0)
            self.trailingConstraint.constant = widtConstraint
        }
    }
}
