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
    let nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //UI setting
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 10
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.backgroundColor = .white
        addSubview(bubbleBackgroundView)

        nameLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        addSubview(nameLabel)
        
        messageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        addSubview(messageLabel)

        //UI constraints
        let constraints = [
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        nameLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: 0),
        nameLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 0),
        nameLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8),
        
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        messageLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.75),

        bubbleBackgroundView.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),
        bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
        bubbleBackgroundView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8)]

        NSLayoutConstraint.activate(constraints)

        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConversationTableViewCell: ConfigurableView {
    func configure(with model: ConfigureationModel) {
        self.messageLabel.text = model.text
        self.nameLabel.text = model.senderName

        if model.isOutput {
            self.leadingConstraint.isActive = false
            self.trailingConstraint.isActive = true
        } else {
            self.leadingConstraint.isActive = true
            self.trailingConstraint.isActive = false

        }
    }
}
