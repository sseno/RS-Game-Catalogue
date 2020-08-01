//
//  UIImageViewExtension.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit

extension UIImageView {

    func setRounded() {
        layer.cornerRadius = 13
        layer.masksToBounds = true
    }
}
