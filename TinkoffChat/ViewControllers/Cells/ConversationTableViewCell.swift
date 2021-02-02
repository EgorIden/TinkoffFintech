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
    
//    @IBOutlet weak var messageBackground: UIView!
//    @IBOutlet weak var messageLabel: UILabel!
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //UI setting
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 10
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        messageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        addSubview(messageLabel)
        
        //UI constraints
        let constraints = [
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        messageLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.75),
        
        bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
        bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
        bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8)]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConversationTableViewCell: ConfigurableView{
    func configure(with model: ConfigureationModel) {
        self.messageLabel.text = model.text
        
        if model.isOutput{
            self.bubbleBackgroundView.backgroundColor = .white
            self.messageLabel.textColor = .black
            self.leadingConstraint.isActive = false
            self.trailingConstraint.isActive = true
        }else{
            self.bubbleBackgroundView.backgroundColor = .lightGray
            self.messageLabel.textColor = .white
            self.leadingConstraint.isActive = true
            self.trailingConstraint.isActive = false
            
        }
    }
}
