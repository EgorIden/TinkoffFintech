//
//  AvatarViewController.swift
//  TinkoffChat
//
//  Created by Egor on 23/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

class AvatarViewController: UIViewController, IAvatarModelDelegate {
    // MARK: UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect.backgroundColor = .white
        return collect
    }()
    // Images URLs
    private var dataSource = [Image]()
    var model: IAvatarModel?
    var imageHandler: ((UIImage?) -> Void)?
    private var emblem: EmblemAnimation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.addAnimation()
        self.model?.fetchURL()
    }
    private func addAnimation() {
        self.emblem = EmblemAnimation(view: self.view)
    }
    private func setupViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "AvatarCell")
        view.backgroundColor = .white
        view.addSubview(collectionView)
        setupLayouts()
    }
    private func setupLayouts() {
        let constraintsCollection = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(constraintsCollection)
    }
    func loadURL(urls: [Image]) {
        self.dataSource = urls
        print("load ->\(urls.count)")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
extension AvatarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("data sours count ->\(dataSource.count)")
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as? AvatarCell else {return UICollectionViewCell()}
        let imageURL = dataSource[indexPath.row].userImageURL
        self.model?.fetchImage(imageURL: imageURL, completion: { (image) in
            DispatchQueue.main.async {
                cell.configure(img: image)
                cell.layoutIfNeeded()
            }
        })
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageURL = dataSource[indexPath.row].userImageURL
        self.model?.fetchImage(imageURL: imageURL, completion: { [weak self] (image) in
            guard let slf = self else { return }
            DispatchQueue.main.async {
                slf.imageHandler?(image)
                slf.dismiss(animated: true, completion: nil)
            }
        })
    }
}
extension AvatarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-20)/3 - 10
        let height = (view.frame.width-20)/3 - 10
        return CGSize(width: width, height: height)
    }
}
