//
//  CustomProgressView.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 07/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit

class CustomProgressView: UIProgressView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.progressViewStyle = .bar
        self.progressTintColor = .systemGreen
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
