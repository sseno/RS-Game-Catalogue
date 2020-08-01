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
import RealmSwift

class GameListCell: LBTAListCell<GameViewModel> {

    private lazy var gameImg: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor(named: "imageBackgroundColor")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    let containerView = UIView(backgroundColor: UIColor(named: "backgroundColor") ?? UIColor.systemBackground)
    let nameLabel = UILabel(font: .boldSystemFont(ofSize: 24), textColor: UIColor(named: "textColor") ?? UIColor.systemGray, numberOfLines: 2)
    let genreLabel = UILabel(font: .systemFont(ofSize: 18), textColor: UIColor(named: "textColorTwo") ?? UIColor.systemGray, numberOfLines: 2)
    let releaseDateLabel = UILabel(text: "-", font: .systemFont(ofSize: 14), textColor: UIColor(named: "textColorTwo") ?? UIColor.systemGray)
    let ratingLabel = UILabel(text: "4.5", font: .systemFont(ofSize: 14), textColor: UIColor(named: "textColorTwo") ?? UIColor.systemGray)
    let bookmarkButton = UIButton(image: UIImage(named: "bookmark.fill")?.withRenderingMode(.alwaysTemplate) ?? UIImage(), tintColor: UIColor(named: "bookmarkButtonColor") ?? UIColor.systemGray)
    let gradientImg = UIImageView(image: UIImage(named: "img_gradient") ?? UIImage(), contentMode: .scaleAspectFill)

    var gamesRealm = [GameRealmResult]()

    override var item: GameViewModel! {
        didSet {
            gameImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            if let stringURL = item.gameResult.backgroundImage {
                gameImg.sd_setImage(with: URL(string: stringURL), placeholderImage: nil, completed: nil)
            }
            nameLabel.text = item.gameResult.name
            genreLabel.text = item.genres
            releaseDateLabel.text = item.gameResult.released
            ratingLabel.text = "\(item.gameResult.rating ?? 0.0) ★"
            bookmarkButton.tintColor = item.isBookmarked ? UIColor(named: "lipstikColor") : UIColor(named: "bookmarkButtonColor")
        }
    }

    override func setupViews() {
        super.setupViews()
        gameImg.setRounded()
        setupBookmarkButton()
        setupContainerView()
        stack(gameImg)
        setupImageGradient()
        stack(gradientImg,UIView())
        stack(hstack(UIView(),bookmarkButton).withMargins(.init(top: -2, left: 0, bottom: 0, right: 8)),
              UIView(),
              containerView).withMargins(.allSides(0))
        containerView.stack(nameLabel,
                            genreLabel,
                            containerView.hstack(releaseDateLabel,
                                                 UIView(),
                                                 ratingLabel,
                                                 spacing: 5),
                            spacing: 5).withMargins(.allSides(12))
        makeCardLayout()
    }

    // MARK: - Private function
    private func setupContainerView() {
        containerView.layer.cornerRadius = 13
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    private func setupImageGradient() {
        gradientImg.withWidth(self.frame.width)
        gradientImg.withHeight(self.frame.height / 3)
        gradientImg.layer.cornerRadius = 13
        gradientImg.clipsToBounds = true
        gradientImg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func setupBookmarkButton() {
        bookmarkButton.withWidth(30).withHeight(36)
        bookmarkButton.contentVerticalAlignment = .fill
        bookmarkButton.contentHorizontalAlignment = .fill
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }

    // MARK: - Action
    @objc func bookmarkTapped() {
        let data = GameRealmResult()
        if let id = item.gameResult.id {
            data.id = id
            data.name = item.gameResult.name
            data.backgroundImage = item.gameResult.backgroundImage
            data.genres = item.genres
            data.released = item.gameResult.released
            data.rating = item.gameResult.rating ?? 0
            data.isBookmarked = bookmarkButton.tintColor == UIColor(named: "lipstikColor") ? false : true
            addBookmark(object: data)
        }
    }

    private func addBookmark(realm: Realm = try! Realm(), object: GameRealmResult) {
        var isBookmarked = false
        do {
            try realm.write {
                realm.add(object, update: .all)
                isBookmarked = object.isBookmarked
                bookmarkButton.tintColor = isBookmarked ? UIColor(named: "lipstikColor") : UIColor(named: "bookmarkButtonColor")
                let parent = parentController as? MainViewController
                parent?.reloadFab()
            }
        } catch let error as NSError {
            PrintDebug.printDebugGeneral(self, message: "error saving data \(error.localizedDescription)")
        }
    }

}
