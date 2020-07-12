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
    let containerView = UIView(backgroundColor: UIColor(named: "backgroundColor")!)
    let nameLabel = UILabel(font: .boldSystemFont(ofSize: 24), textColor: UIColor(named: "textColor")!, numberOfLines: 2)
    let genreLabel = UILabel(font: .systemFont(ofSize: 18), textColor: UIColor(named: "textColorTwo")!, numberOfLines: 2)
    let releaseDateLabel = UILabel(text: "-", font: .systemFont(ofSize: 14), textColor: UIColor(named: "textColorTwo")!)
    let ratingLabel = UILabel(text: "4.5", font: .systemFont(ofSize: 14), textColor: UIColor(named: "textColorTwo")!)

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
            releaseDateLabel.text = item.released
            ratingLabel.text = "\(item.rating ?? 0.0) ★"
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
                            containerView.hstack(releaseDateLabel,
                                                 UIView(),
                                                 ratingLabel,
                                                 spacing: 5),
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
