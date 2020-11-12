//
//  ConversationsTableViewCell.swift
//  TinkoffChat
//
//  Created by Egor on 29/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class ConversationsTableViewCell: UITableViewCell {

    typealias ConfigureationModel = ConversationCellModel
    private let formatter = DateFormatter()

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var messageLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.messageLable.textColor = .lightGray
        self.messageLable.text = nil
        self.backgroundColor = .white
    }
}

extension ConversationsTableViewCell: ConfigurableView {
    func configure(with model: ConfigureationModel) {

        self.nameLable.text = model.name

        if model.isOnline {
            self.backgroundColor = UIColor.init(red: 255/255, green: 252/255,
                                                blue: 98/255, alpha: 0.2)
        }

        if model.hasUnreadedMessages {
            messageLable.font = .boldSystemFont(ofSize: 16)
            messageLable.textColor = .black
            messageLable.text = model.message
        } else if model.message == "" {
            messageLable.font = .italicSystemFont(ofSize: 16)
            messageLable.text = "No messages yet"
        } else {
            messageLable.font = .systemFont(ofSize: 16)
            messageLable.text = model.message
        }

        let formatter = DateFormatter()

        if Calendar.current.isDateInToday(model.date) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd MMM"
        }
        dateLable.text = formatter.string(from: model.date)

    }
}
