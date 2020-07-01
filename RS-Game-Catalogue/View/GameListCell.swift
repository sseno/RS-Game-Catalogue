//
//  GameListCell.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools

class GameListCell: LBTAListCell<GameResults> {

    let nameLabel = UILabel()

    override var item: GameResults! {
        didSet {
            nameLabel.text = item.name
        }
    }

    override func setupViews() {
        super.setupViews()
        backgroundColor = .systemGreen
        stack(nameLabel,
              alignment: .center)
    }
}
