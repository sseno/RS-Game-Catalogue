//
//  EditViewController.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 02/08/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import Foundation
import UIKit
import LBTATools

class EditViewController: LBTAFormController {

    let nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16), textColor: UIColor(named: "textColor") ?? UIColor.systemGray)
    let cityLabel = UILabel(text: "City", font: .systemFont(ofSize: 16), textColor: UIColor(named: "textColor") ?? UIColor.systemGray)
    let emailLabel = UILabel(text: "Email", font: .systemFont(ofSize: 16), textColor: UIColor(named: "textColor") ?? UIColor.systemGray)

    let nameTextField = IndentedTextField(placeholder: "Rohmat Suseno")
    let cityTextField = IndentedTextField(placeholder: "City", padding: 8)
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 8, keyboardType: .emailAddress)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
    }

    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        formContainerStackView.axis = .vertical
        formContainerStackView.layoutMargins = .init(top: 40, left: 25, bottom: 25, right: 25)
        formContainerStackView.spacing = 25

        nameTextField.isEnabled = false
        let hStackView = UIStackView(arrangedSubviews: [nameLabel.withWidth(70), nameTextField, UIView()])
        hStackView.axis = .horizontal

        cityTextField.text = UserDefaultManager.instance.userCity
        cityTextField.borderStyle = .roundedRect
        cityTextField.withWidth(UIScreen.main.bounds.width - 70 - 50)
        cityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let hStackViewCity = UIStackView(arrangedSubviews: [cityLabel.withWidth(70), cityTextField, UIView()])
        hStackView.axis = .horizontal

        emailTextField.text = UserDefaultManager.instance.userEmail
        emailTextField.borderStyle = .roundedRect
        emailTextField.withWidth(UIScreen.main.bounds.width - 70 - 50)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let hStackViewEmail = UIStackView(arrangedSubviews: [emailLabel.withWidth(70), emailTextField, UIView()])
        hStackView.axis = .horizontal

        formContainerStackView.addArrangedSubview(hStackView)
        formContainerStackView.addArrangedSubview(hStackViewCity)
        formContainerStackView.addArrangedSubview(hStackViewEmail)
    }

    private func setupNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        self.title = "Edit Profile"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    // MARK: - Actions
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func doneTapped() {
        if let city = cityTextField.text, let email = emailTextField.text {
            UserDefaultManager.instance.userCity = city
            UserDefaultManager.instance.userEmail = email
        }
         self.dismiss(animated: true, completion: nil)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == cityTextField || textField == emailTextField {
            if textField.text == "" || cityTextField.text == UserDefaultManager.instance.userCity && emailTextField.text == UserDefaultManager.instance.userEmail {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
}

#if DEBUG
import SwiftUI

struct EditViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           EditContentView().previewDevice(.init(stringLiteral: "iPhone X"))
              .environment(\.colorScheme, .light)

//           EditContentView().previewDevice(.init(stringLiteral: "iPhone 11"))
//              .environment(\.colorScheme, .dark)
        }
    }

    struct EditContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> EditViewController {
            return EditViewController()
        }

        func updateUIViewController(_ uiViewController: EditViewController, context: Context) {
            //
        }
    }
}
#endif
