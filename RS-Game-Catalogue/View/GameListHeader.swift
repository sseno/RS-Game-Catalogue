//
//  GameListHeader.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools

class GameListHeader: UICollectionReusableView {

    let headerController = MainHeaderViewController(scrollDirection: .horizontal)
    private lazy var titleLabel: UILabel = {
        return UILabel(text: "The Latest Released", font: .boldSystemFont(ofSize: 16), textColor: .blackTwo)
    }()
    private lazy var scndtitleLabel: UILabel = {
        return UILabel(text: "The Most Popular", font: .boldSystemFont(ofSize: 16), textColor: .blackTwo)
    }()

//    var delegate: ViralHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        //stack(headerController.view)
//
//        viralController.delegate = self
        //headerController.collectionView.showsHorizontalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
