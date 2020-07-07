//
//  UIViewExtension.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit

extension UIView {

    func makeCardLayout(shadowPath: UIBezierPath = UIBezierPath()) {
        layer.shadowColor = UIColor.init(white: 0, alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowRadius = 15.0
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.cornerRadius = 13
        layer.masksToBounds = false

        backgroundColor = .white

    }
}
