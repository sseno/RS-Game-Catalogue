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
        self.collectionView.backgroundColor = .systemPurple

        getLatestReleased()
    }

    private func getLatestReleased(date: String = "2020-05-24,2020-06-30", platforms: String = "3") {
        // show loading
        ApiManager.shared.getLatestReleased(by: date, id: platforms) { [weak self] result in
            guard let self = self else { return }
            // hide loading
            switch result {
            case .success(let games):
                self.updateUI(with: games)
            case .failure(let error):
                self.showError(with: error.rawValue)
            }
        }
    }

    private func updateUI(with data: GameResponse) {
        if let results = data.results, !results.isEmpty {
            for result in results {
                self.items.append(result)
             }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                let message = "Sorry, data is empty :("
                self.showError(with: message)
            }
        }
    }

    private func showError(with error: String) {
        print(error)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width - 28 - 20) / 2, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 14, bottom: 30, right: 14)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 338)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.items[indexPath.row].name as Any)
    }
}

import SwiftUI

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(.init(stringLiteral: "iPhone 11 Pro"))
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
