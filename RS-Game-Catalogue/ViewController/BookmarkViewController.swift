//
//  BookmarkViewController.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 01/08/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools

class BookmarkViewController: LBTAListController<GameBookmarkedCell, GameRealmResult> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }

    private func setupUI() {
        self.title = "Bookmarks"
        self.collectionView.backgroundColor = .systemBackground
    }

    private func getData() {
        let listOfGames = GameRealmResult.get(isBookmarked: true)
        if listOfGames.count != 0 {
            self.items.append(contentsOf: listOfGames.reversed())

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.notificationReloadFab), object: nil)
            self.navigationController?.popViewController(animated: false)
        }
    }

    func reloadItems() {
        self.items.removeAll()
        getData()
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension BookmarkViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        return .init(width: width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.gameID = items[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
