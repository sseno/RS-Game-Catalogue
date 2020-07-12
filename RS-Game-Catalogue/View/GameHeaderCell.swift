//
//  GameHeaderCell.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 04/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools

class GameHeaderCell: LBTAListCell<ListDeveloperResults> {

    private lazy var titleLabel: UILabel = {
        return UILabel(font: .systemFont(ofSize: 16), textColor: UIColor(named: "textColor")!, textAlignment: .center, numberOfLines: 1)
    }()
    lazy var indicatorColor: UIView = {
        return UIView(backgroundColor: .clear)
    }()

    override var item: ListDeveloperResults! {
        didSet {
            if item.id == DEVELOPER_ID {
                indicatorColor.backgroundColor = .systemBlue
                titleLabel.font = .boldSystemFont(ofSize: 16)
            }
            titleLabel.text = item.name
        }
    }

    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16)
            indicatorColor.backgroundColor = isSelected ? .systemBlue : .clear
        }
    }

    override func setupViews() {
        super.setupViews()
        indicatorColor.layer.cornerRadius = 4
        indicatorColor.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        stack(UIView(),
              indicatorColor.withHeight(4)).withMargins(.allSides(0))
        stack(titleLabel)
    }
}
