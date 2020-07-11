//
//  GameListCell.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools
import SDWebImage

class GameListCell: LBTAListCell<GameResults> {

    private lazy var gameImg: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor(named: "imageBackgroundColor")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    private lazy var nameLabel: UILabel = {
        return UILabel(font: .boldSystemFont(ofSize: 24), textColor: UIColor(named: "textColor")!, numberOfLines: 2)
    }()
    private lazy var genreLabel: UILabel = {
        return UILabel(font: .systemFont(ofSize: 18), textColor: UIColor(named: "textColorTwo")!, numberOfLines: 2)
    }()
    private lazy var containerView: UIView = {
        return UIView(backgroundColor: UIColor(named: "backgroundColor")!)
    }()

    override var item: GameResults! {
        didSet {
            if let stringURL = item.backgroundImage {
                gameImg.sd_setImage(with: URL(string: stringURL), placeholderImage: nil, completed: nil)
            }
            nameLabel.text = item.name
            if let gendres = item.genres {
                let arr = gendres.map{ $0.name ?? ""}
                genreLabel.text = arr.joined(separator: ", ")
            }
        }
    }

    override func setupViews() {
        super.setupViews()
        gameImg.setRounded()
        setupContainerView()
        stack(gameImg)
        stack(UIView(),
              containerView).withMargins(.allSides(0))
        containerView.stack(nameLabel,
                            genreLabel,
                            spacing: 5).withMargins(.allSides(12))
        self.makeCardLayout(shadowPath: UIBezierPath(roundedRect: bounds, cornerRadius: self.contentView.layer.cornerRadius))
    }

    // MARK: - Private function
    private func setupContainerView() {
        containerView.layer.cornerRadius = 13
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

}
