//
//  AvatarViewController.swift
//  TinkoffChat
//
//  Created by Egor on 18/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController, IAvatarModelDelegate {
    // MARK: UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collect
    }()
    // Images URLs
    private var dataSource = [Image]()
    var model: IAvatarModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.model?.fetch()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "AvatarCell")
        setupLayouts()
    }
    private func setupLayouts() {
        collectionView.backgroundColor = .white
        let constr = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(constr)
    }
    func load(images: [Image]) {
        self.dataSource = images
        print("load ->\(images.count)")
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath)as? AvatarCell else {return UICollectionViewCell()}
        let imageData = dataSource[indexPath.row]
        return cell
    }
}
extension AvatarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-20)/3 - 10
        let height = (view.frame.width-20)/3 - 10
        return CGSize(width: width, height: height)
    }
}
