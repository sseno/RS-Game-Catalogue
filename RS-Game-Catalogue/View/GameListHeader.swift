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

//    let viralController = ViralController(scrollDirection: .horizontal)
//    let viralLabel = UILabel(text: NSLocalizedString("Viral Video", comment: ""),
//                             font: R.font.robotoMedium(size: 16),
//                             textColor: UIColor.INewsColor.Black.blackThree)
//    let videoLabel = UILabel(text: NSLocalizedString("Latest Video", comment: ""),
//                             font: R.font.robotoMedium(size: 16),
//                             textColor: UIColor.INewsColor.Black.blackThree)
//
//    var delegate: ViralHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemYellow
//        stack(UIView().withHeight(15),
//              hstack(UIView().withWidth(15),viralLabel),
//              viralController.view,
//              hstack(UIView().withWidth(15),videoLabel))
//
//        viralController.delegate = self
//        viralController.collectionView.showsHorizontalScrollIndicator = false
//        viralLabel.theme_textColor = "Global.barTextColor"
//        videoLabel.theme_textColor = "Global.barTextColor"
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
