//
//  AvatarCell.swift
//  TinkoffChat
//
//  Created by Egor on 18/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
protocol IAvatarCell {
    var avatarImage: UIImageView {get set}
}
class AvatarCell: UICollectionViewCell, IAvatarCell {
    var avatarImage: UIImageView = {
        let img = UIImageView(frame: .zero)
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    func setupLayout(){
        backgroundColor = .red
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImage)
        let constraints = [
            avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            avatarImage.bottomAnchor.constraint(equalTo: topAnchor, constant: 0),
            avatarImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(data: Data){
        let img = UIImage(data: data)
        avatarImage.image = img
    }
}
