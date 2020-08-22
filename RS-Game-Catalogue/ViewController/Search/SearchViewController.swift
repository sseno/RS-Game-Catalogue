//
//  SearchViewController.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 11/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools

class SearchViewController: LBTAListController<GameListCell, GameViewModel> {

    let searchBar = UISearchBar()
    var searchKeyword = ""
    var page = 1

    var hasMorePage = false
    var isRequesting = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        extendedLayoutIncludesOpaqueBars = true
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.contentInset = .init(top: 20, left: 16, bottom: 25, right: 16)
//        self.collectionView.keyboardDismissMode = .interactive

        searchBar.placeholder = "Game name"
        searchBar.sizeToFit()
        searchBar.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.searchBar.becomeFirstResponder()
        }

        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }

    @objc func getGames() {
        if searchKeyword != "" {
            showLoadingIndicator(true, withBlocking: page == 1 ? true : false)
            ApiManager.shared.getGames(query: searchKeyword.replacingOccurrences(of: " ", with: "%20"), page: page, completed: { [weak self] result in
                guard let self = self else { return }
                self.showLoadingIndicator(false, withBlocking: self.page == 1 ? true : false)
                switch result {
                case .success(let games):
                    self.updateUI(with: games, page: self.page)
                case .failure(let error):
                    self.showAlertOnMainThread(message: error.rawValue)
                }

                self.isRequesting = false
            })
        }
    }

    private func updateUI(with data: GameResponse, page: Int) {
        if let results = data.results, !results.isEmpty {
            hasMorePage = data.next != nil ? true : false
            if page == 1 {
                items.removeAll()
            }
            for result in results {
                let data = GameViewModel(data: result)
                self.items.append(data)
            }
            DispatchQueue.main.async {
                if page == 1 {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                self.collectionView.reloadData()
                self.searchBar.resignFirstResponder()
            }
        } else {
            DispatchQueue.main.async {
                self.showAlertOnMainThread(message: "Sorry, data is empty :(")
            }
        }
    }

    // MARK: - Actions
    @objc func cancelTapped() {
        NotificationCenter.default.post(name: .notificationReloadFab, object: nil)
        self.navigationController?.popViewController(animated: false)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.items.count - 1 {
            if hasMorePage {
                if !isRequesting {
                    isRequesting = true
                    page += 1
                    getGames()
                } else {
                    PrintDebug.printDebugGeneral(self, message: "lagi loading")
                }
            } else {
                PrintDebug.printDebugGeneral(self, message: "no more data")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        return .init(width: width, height: width + 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        guard let id = items[indexPath.row].gameResult.id else { return }
        vc.gameID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchKeyword = searchText
        page = 1
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getGames), object: searchBar)
        perform(#selector(getGames), with: searchBar, afterDelay: 1.0)
    }
}
