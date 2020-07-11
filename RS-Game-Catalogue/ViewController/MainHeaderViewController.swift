//
//  MainHeaderViewController.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools

var DEVELOPER_ID = 0

class MainHeaderViewController: LBTAListController<GameHeaderCell, ListDeveloperResults> {

    private lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "lineColor")!
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getDevelopers()
    }

    private func setupUI() {
        self.collectionView.backgroundColor = .systemBackground
        self.view.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            lineView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }

    private func getDevelopers() {
        ApiManager.shared.getDevelopers() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.updateUI(with: games)
            case .failure(let error):
                self.showLoadingIndicator(false)
                self.showAlertOnMainThread(message: error.rawValue)
            }
        }
    }

    private func updateUI(with data: ListDeveloperResponse) {

        if let results = data.results, !results.isEmpty, results.count > 0 {

            for (index, result) in results.enumerated() {
                if index == 0 {
                    DEVELOPER_ID = results[index].id ?? 0
                }
                items.append(result)
             }

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.NotificationReloadItemGames), object: nil, userInfo: ["developerID" : DEVELOPER_ID])

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        else {
            DispatchQueue.main.async {
                let message = "Sorry, data is empty :("
                self.showAlertOnMainThread(message: message)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainHeaderViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = items[indexPath.row].name ?? ""
        let width = self.estimatedFrame(text: text, font: .systemFont(ofSize: 13)).width
        return CGSize(width: width + 50, height: 55)
    }

    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 55)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 0, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? GameHeaderCell
        cell?.indicatorColor.backgroundColor = .systemBlue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            DEVELOPER_ID = self.items[indexPath.row].id ?? 0
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.NotificationReloadItemGames), object: nil, userInfo: ["developerID" : DEVELOPER_ID])
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? GameHeaderCell
        cell?.indicatorColor.backgroundColor = .clear
    }
}
