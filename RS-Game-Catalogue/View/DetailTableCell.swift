//
//  DetailTableCell.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 06/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit

protocol DetailTableCellDelegate: class {
    func arrowRightTapped()
}

class DetailTableCell: UITableViewCell {

    private let developerLabel = UILabel(font: .boldSystemFont(ofSize: 13), textColor: UIColor(named: "textColor")!, numberOfLines: 1)
    private let getButton = UIButton(title: "GET", titleColor: .white, font: .boldSystemFont(ofSize: 14), backgroundColor: .systemBlue)
    private let titleLabel = UILabel(font: .boldSystemFont(ofSize: 22), textColor: UIColor(named: "textColor")!, numberOfLines: 0)
    private let releaseDateLabel = UILabel(font: .boldSystemFont(ofSize: 14), textColor: UIColor(named: "textColor")!)
    private let imgHeader = UIImageView(image: nil, contentMode: .scaleAspectFill)
    private let aboutLabel = UILabel(text: "About this game", font: .boldSystemFont(ofSize: 18), textColor: UIColor(named: "textColor")!)
    private let arrowRightButton = UIButton(image: UIImage(named: "chevron.right")!, tintColor: UIColor(named: "textColor")!)
    private let descLabel = UILabel(font: .systemFont(ofSize: 16), textColor: UIColor(named: "textColor")!, numberOfLines: 3)
    private let lineView = UIView(backgroundColor: UIColor(named: "lineColor")!)
    private let ratingsLabel = UILabel(text: "Ratings", font: .boldSystemFont(ofSize: 18), textColor: UIColor(named: "textColor")!)
    private let vStackView = UIStackView()

    weak var delegate: DetailTableCellDelegate?

    var data: GameDetailResponse?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        imgHeader.backgroundColor = UIColor(named: "imageBackgroundColor")
        aboutLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)

        getButton.addTarget(self, action: #selector(getButtonTapped(_:)), for: .touchUpInside)
        getButton.layer.cornerRadius = 15
        arrowRightButton.addTarget(self, action: #selector(arrowRightTapped), for: .touchUpInside)
        setupRatingView()

        self.contentView.stack(contentView.hstack(contentView.stack(developerLabel,
                                                                    titleLabel,
                                                                    releaseDateLabel,
                                                                    spacing: 5),
                                                  UIView(),
                                                  getButton.withWidth(60).withHeight(30),
                                                  spacing: 3,
                                                  alignment: .center)
                        .withMargins(.init(top: 0, left: 20, bottom: 0, right: 20)),
                               imgHeader.withHeight(250),
                               contentView.stack(contentView.hstack(aboutLabel,
                                                                    UIView(),
                                                                    arrowRightButton),
                                                 descLabel,
                                                 lineView.withHeight(1),
                                                 ratingsLabel,
                                                 vStackView,
                                                 spacing: 20)
                        .withMargins(.init(top: 0, left: 20, bottom: 0, right: 20)),
                               spacing: 20)
            .withMargins(.init(top: 20, left: 0, bottom: 20, right: 0))
    }

    private func setupRatingView() {
        vStackView.axis = .vertical
        vStackView.spacing = 8
    }

    func setData(_ data: GameDetailResponse) {
        self.data = data
        if data.stores?.count == 0 { getButton.isHidden = true }
        if let imageURL = data.backgroundImage {
            imgHeader.sd_setImage(with: URL(string: imageURL), placeholderImage: nil, completed: nil)
        }
        titleLabel.text = data.name
        descLabel.attributedText = data.description?.htmlToAttributedString
        releaseDateLabel.text = data.released
        if let developers = data.developers {
            for developer in developers {
                developerLabel.text = developer.name
            }
        }
        if let ratings = data.ratings, ratings.count > 0 {
            for rating in ratings {
                let hStackView = UIStackView()
                hStackView.axis = .horizontal
                hStackView.spacing = 8
                hStackView.alignment = .center

                let ratingName = UILabel(font: .systemFont(ofSize: 14), textColor: UIColor(named: "textColor")!)
                let progressView = CustomProgressView()
                progressView.transform = CGAffineTransform(scaleX: 1, y: 3)
                
                ratingName.text = rating.title?.capitalized
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 4.0) {
                        progressView.setProgress(Float(rating.percent ?? 0.0) / 100, animated: true)
                    }
                }

                hStackView.addArrangedSubview(ratingName.withWidth(150))
                hStackView.addArrangedSubview(progressView)

                vStackView.addArrangedSubview(hStackView)
            }
            vStackView.layoutIfNeeded()
        }
        else {
            ratingsLabel.isHidden = true
        }
    }

    // MARK: - Actions
    @objc func getButtonTapped(_ sender: UIButton) {
        guard let storeCount = self.data?.stores?.count, storeCount > 0 else { return }

        if let url = self.data?.stores?[0].url, url != "" {
            if let urlStr = URL(string: url),
                UIApplication.shared.canOpenURL(urlStr) {
                UIApplication.shared.open(urlStr, options: [:], completionHandler: nil)
            }
        }
    }

    @objc func arrowRightTapped() {
        delegate?.arrowRightTapped()
    }
}
