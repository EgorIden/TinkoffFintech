//
//  AvatarCell.swift
//  TinkoffChat
//
//  Created by Egor on 23/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
protocol IAvatarCell {
    var avatarImage: UIImageView {get set}
}
class AvatarCell: UICollectionViewCell, IAvatarCell {
    // UI
    var avatarImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews() {
        self.contentView.backgroundColor = .lightGray
        self.indicator.startAnimating()
        self.contentView.addSubview(avatarImage)
        self.contentView.addSubview(indicator)
        setupLayout()
    }
    func setupLayout() {
        let constraints = [
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            avatarImage.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            avatarImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: 0),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(constraints)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(img: UIImage?) {
        self.indicator.stopAnimating()
        avatarImage.image = img
    }
}
