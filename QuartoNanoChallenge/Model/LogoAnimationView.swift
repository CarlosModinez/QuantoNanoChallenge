//
//  LogoAnimationView.swift
//  QuartoNanoChallenge
//
//  Created by akira tsukamoto on 01/04/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import SwiftyGif

class LogoAnimationView: UIView {

   let logoGifImageView = try! UIImageView(gifImage: UIImage(gifName: "LaunchScreen.gif"), loopCount: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        logoGifImageView.widthAnchor.constraint(equalToConstant: 280).isActive = true
//        logoGifImageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
    }
}
extension UIView {
    
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
}
