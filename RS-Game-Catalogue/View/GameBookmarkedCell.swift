//
//  GameBookmarkedCell.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 01/08/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools
import RealmSwift
import SDWebImage

class GameBookmarkedCell: LBTAListCell<GameRealmResult> {

    private lazy var gameImg: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor(named: "imageBackgroundColor")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    let nameLabel = UILabel(font: .boldSystemFont(ofSize: 16), textColor: UIColor(named: "textColor") ?? UIColor.systemGray)
    let genreLabel = UILabel(font: .systemFont(ofSize: 14), textColor: UIColor(named: "textColorTwo") ?? UIColor.systemGray)
    let releaseDateLabel = UILabel(text: "-", font: .systemFont(ofSize: 12), textColor: UIColor(named: "textColorTwo") ?? UIColor.systemGray)
    let ratingLabel = UILabel(text: "4.5", font: .systemFont(ofSize: 12), textColor: UIColor(named: "textColorTwo") ?? UIColor.systemGray)
    let bookmarkButton = UIButton(image: UIImage(named: "bookmark.fill")?.withRenderingMode(.alwaysTemplate) ?? UIImage(), tintColor: UIColor(named: "lipstikColor") ?? UIColor.systemRed)

    override var item: GameRealmResult! {
        didSet {
            gameImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            if let stringURL = item.backgroundImage {
                gameImg.sd_setImage(with: URL(string: stringURL), placeholderImage: nil, completed: nil)
            }
            nameLabel.text = item.name
            genreLabel.text = item.genres
            releaseDateLabel.text = item.released
            ratingLabel.text = "\(item.rating ) ★"
        }
    }

    override func setupViews() {
        super.setupViews()
        backgroundColor = .clear
        setupGameImage()
        setupBookmarkButton()

        hstack(gameImg,
               UIView().withWidth(16),
               stack(nameLabel,
                     genreLabel,
                     releaseDateLabel,
                     ratingLabel,
                     spacing: 5),
               UIView(),
               stack(bookmarkButton,
                     UIView()))
            .withMargins(.allSides(0))
    }

    // MARK: - Private functions
    private func setupGameImage() {
        gameImg.withSize(.init(width: 80, height: 80))
        gameImg.layer.cornerRadius = 8
        gameImg.clipsToBounds = true
    }

    private func setupBookmarkButton() {
        bookmarkButton.withWidth(20).withHeight(25)
        bookmarkButton.contentVerticalAlignment = .fill
        bookmarkButton.contentHorizontalAlignment = .fill
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }

    // MARK: - Action
    @objc func bookmarkTapped() {
        let object = GameRealmResult()
        object.id = item.id
        object.isBookmarked = false
        updateBookmark(object: object)
    }

    private func updateBookmark(realm: Realm = try! Realm(), object: GameRealmResult) {
        do {
            try realm.write {
                realm.add(object, update: .all)
                let parent = parentController as? BookmarkViewController
                parent?.reloadItems()
            }
        } catch let error as NSError {
            PrintDebug.printDebugGeneral(self, message: "error updating data \(error.localizedDescription)")
        }
    }

}
