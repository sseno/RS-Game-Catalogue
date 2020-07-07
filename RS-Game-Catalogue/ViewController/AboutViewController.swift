//
//  AboutViewController.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 05/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit
import LBTATools

class AboutViewController: UIViewController {

    private let imgProfile = UIImageView(image: UIImage(named: "profile_rohmats"), contentMode: .scaleAspectFill)
    private let nameLabel: UILabel = UILabel(text: "Rohmat Suseno",
                                             font: .boldSystemFont(ofSize: 16),
                                             textColor: UIColor(named: "textColor")!)
    private let addressLabel: UILabel = UILabel(text: "Yogyakarta",
                                                font: .systemFont(ofSize: 14),
                                                textColor: UIColor(named: "textColor")!)
    private let emailLabel: UILabel = UILabel(text: "rohmatsuseno@gmail.com",
                                              font: .systemFont(ofSize: 14),
                                              textColor: UIColor(named: "textColor")!)
    private let aboutTitleLabel: UILabel = UILabel(text: "About this app",
                                               font: .boldSystemFont(ofSize: 16),
                                               textColor: UIColor(named: "textColor")!)
    private let descriptionLabel: UILabel = UILabel(text: "Aplikasi ini menyajikan daftar game melalui API yang diperoleh dari https://api.rawg.io/. Pada halaman utama merupakan daftar game berdasarkan developer. Terdapat fitur pencarian menggunakan query maupun tanggal.",
                                                    font: .systemFont(ofSize: 16),
                                                    textColor: UIColor(named: "textColor")!,
                                                    numberOfLines: 0)
    private let lineView = UIView(backgroundColor: UIColor(named: "lineColor")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        imgProfile.layer.cornerRadius = 130 / 2
        view.stack(view.stack(imgProfile.withWidth(130).withHeight(130),
                              alignment: .center)
            .withMargins(.init(top: 0, left: 0, bottom: 20, right: 0)),
                   nameLabel,
                   addressLabel,
                   emailLabel,
                   UIView().withHeight(12),
                   lineView.withHeight(1),
                   UIView().withHeight(12),
                   aboutTitleLabel,
                   descriptionLabel,
                   UIView(),
                   spacing: 8)
            .withMargins(.init(top: 0, left: 23, bottom: 0, right: 23))
    }
}

#if DEBUG
import SwiftUI

struct AboutViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           AboutContentView().previewDevice(.init(stringLiteral: "iPhone 6s"))
              .environment(\.colorScheme, .light)

           AboutContentView().previewDevice(.init(stringLiteral: "iPhone 11 Pro"))
              .environment(\.colorScheme, .dark)
        }
    }

    struct AboutContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> AboutViewController {
            return AboutViewController()
        }

        func updateUIViewController(_ uiViewController: AboutViewController, context: Context) {
            //
        }
    }
}
#endif