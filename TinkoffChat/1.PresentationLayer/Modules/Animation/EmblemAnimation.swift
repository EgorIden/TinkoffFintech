//
//  EmblemAnimation.swift
//  TinkoffChat
//
//  Created by Egor on 26/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
final class EmblemAnimation {
    private let view: UIView
    private let panGesture = UIPanGestureRecognizer()
    private let tapGesture = UITapGestureRecognizer()
    private let presshGesture = UILongPressGestureRecognizer()
    init(view: UIView) {
        self.view = view
        self.panGesture.addTarget(self, action: #selector(panAction(_:)))
        self.tapGesture.addTarget(self, action: #selector(tapAction(_:)))
        self.presshGesture.addTarget(self, action: #selector(pressAction(_:)))
        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(presshGesture)
    }
    private func animation(view: UIView, touchArea: CGPoint) {
        let rndmSize = Int.random(in: 16...54)
        let rndmRotateAngle = Int.random(in: 180...360)
        let rndmCoord: CGFloat = coord()
        let img = UIImage(named: "emblem")
        let emblem = UIImageView(frame: CGRect(x: touchArea.x-CGFloat(rndmCoord),
                                               y: touchArea.y-CGFloat(rndmCoord),
                                               width: CGFloat(rndmSize),
                                               height: CGFloat(rndmSize)))
        emblem.image = img
        view.addSubview(emblem)
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [.calculationModeCubicPaced],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 1) {
                                                        emblem.transform = CGAffineTransform(rotationAngle: CGFloat(rndmRotateAngle))
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 1) {
                                                        emblem.center.x += CGFloat(rndmCoord)
                                                        emblem.center.y -= CGFloat(rndmCoord)
                                    }
        }) { complete in
            emblem.removeFromSuperview()
            emblem.layoutIfNeeded()
        }
    }
    private func coord() -> CGFloat {
        return CGFloat(Int.random(in: 10...50))
    }
    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        let area = gesture.location(in: self.view)
        self.animation(view: self.view, touchArea: area)
    }
    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        let area = gesture.location(in: self.view)
        self.animation(view: self.view, touchArea: area)
    }
    @objc func pressAction(_ gesture: UILongPressGestureRecognizer) {
        let area = gesture.location(in: self.view)
        self.animation(view: self.view, touchArea: area)
    }
}
