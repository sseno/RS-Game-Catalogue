//
//  DetailViewController.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 05/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools
import SDWebImage

class DetailViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = 44.0
        tableView.register(DetailTableCell.self, forCellReuseIdentifier: Constants.ReuseIdentifier.detailTableCell)
        tableView.isHidden = true
        return tableView
    }()

    var gameID = 327999 // 0
    var gameName = ""
    var data: GameDetailResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        setupUI()
        setupNavBar()
        getGameDetail()
    }

    private func setupUI() {
        self.view.backgroundColor = .systemBackground

        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(shareButtonTapped(_:)), image: UIImage(named: "square.and.arrow.up"), width: 30)
    }

    func getGameDetail() {
        showLoadingIndicator(true)
        ApiManager.shared.getGameDetail(by: gameID) { [weak self] result in
            guard let self = self else { return }
            self.showLoadingIndicator(false)
            switch result {
            case .success(let games):
                self.updateUI(with: games)
            case .failure(let error):
                self.showAlertOnMainThread(message: error.rawValue)
            }
        }
    }

    private func updateUI(with data: GameDetailResponse) {
        DispatchQueue.main.async {
            self.data = data
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }

    // MARK: - Actions
    @objc func shareButtonTapped(_ sender: UIBarButtonItem) {
        if let websiteURL = self.data?.website, websiteURL != "" {
            let items = [URL(string: websiteURL)!]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        } else {
            showAlertOnMainThread(message: "URL is not available.", title: "Uh-oh!")
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.detailTableCell, for: indexPath) as! DetailTableCell
        cell.delegate = self
        if let data = self.data {
            cell.setData(data)
        }
        return cell
    }
}

// MARK: - DetailTableCellDelegate
extension DetailViewController: DetailTableCellDelegate {

    func arrowRightTapped() {
        let vc = MoreDetailViewController()
        if let data = self.data {
            vc.title = data.name
            vc.updateUI(with: data)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

#if DEBUG
import SwiftUI

struct DetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           DetailContentView().previewDevice(.init(stringLiteral: "iPhone 8"))
              .environment(\.colorScheme, .light)

           DetailContentView().previewDevice(.init(stringLiteral: "iPhone X"))
              .environment(\.colorScheme, .dark)
        }
    }

    struct DetailContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> DetailViewController {
            return DetailViewController()
        }

        func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
            //
        }
    }
}
#endif
