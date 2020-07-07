//
//  MainViewController.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import Foundation
import LBTATools

class MainViewController: LBTAListHeaderController<GameListCell, GameResults, GameListHeader> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadItemGames), name: NSNotification.Name(Constants.NotificationName.NotificationReloadItemGames), object: nil)
    }

    private func setupUI() {
        showLoadingIndicator(true)
        self.collectionView.backgroundColor = .systemBackground
        setupNavBar()
    }

    @objc func reloadItemGames(notification: NSNotification) {
        guard let developerID = notification.userInfo!["developerID"] as? Int else { return }
        getGamesByDeveloper(id: developerID)
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "RS-Games"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "person.crop.circle"), style: .plain, target: self, action: #selector(profileTapped(_:)))
    }

    private func getGamesByDeveloper(id developersID: Int = 0) {
        showLoadingIndicator(true, withBlocking: true)
        ApiManager.shared.getGamesByDevelopers(id: developersID) { [weak self] result in
            guard let self = self else { return }
            self.showLoadingIndicator(false, withBlocking: true)
            switch result {
            case .success(let games):
                self.updateUI(with: games)
            case .failure(let error):
                self.showAlertOnMainThread(message: error.rawValue)
            }
        }
    }

    private func updateUI(with data: GameResponse) {
        if let results = data.results, !results.isEmpty {
            items.removeAll()
            for result in results {
                items.append(result)
             }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                let message = "Sorry, data is empty :("
                self.showAlertOnMainThread(message: message)
            }
        }
    }
    // MARK: - Actions
    @objc func searchTapped(_ sender: UIBarButtonItem) {
        print("tapped search")
    }

    @objc func profileTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(AboutViewController(), animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        return .init(width: width, height: width + 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 16, bottom: 25, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 55)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        guard let id = items[indexPath.row].id else { return }
        vc.gameID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

#if DEBUG
import SwiftUI

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           ContentView().previewDevice(.init(stringLiteral: "iPhone 11 Pro"))
              .environment(\.colorScheme, .light)

           ContentView().previewDevice(.init(stringLiteral: "iPhone 11 Pro"))
              .environment(\.colorScheme, .dark)
        }
    }

    struct ContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> MainViewController {
            return MainViewController()
        }

        func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
            //
        }
    }
}
#endif
