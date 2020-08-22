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

    let imageProfile = UIImageView()
    let pickImageLabel = UILabel(text: "Change Profile Photo", textColor: .systemBlue)
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

        // image profile
        imageProfile.backgroundColor = .systemGray
        imageProfile.withWidth(130).withHeight(130)
        imageProfile.layer.cornerRadius = 130 / 2
        imageProfile.clipsToBounds = true
        imageProfile.isUserInteractionEnabled = true
        imageProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageProfileTapped)))

        pickImageLabel.isUserInteractionEnabled = true
        pickImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageProfileTapped)))

        let hStackViewImage = UIStackView(arrangedSubviews: [imageProfile, pickImageLabel])
        hStackViewImage.axis = .vertical
        hStackViewImage.spacing = 15
        hStackViewImage.alignment = .center

        nameTextField.isEnabled = false
        nameTextField.withWidth(UIScreen.main.bounds.width - 70 - 50)

        let hStackView = UIStackView(arrangedSubviews: [nameLabel.withWidth(70), nameTextField, UIView()])

        cityTextField.text = UserDefaultManager.instance.userCity
        cityTextField.borderStyle = .roundedRect
        cityTextField.withWidth(UIScreen.main.bounds.width - 70 - 50)
        cityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let hStackViewCity = UIStackView(arrangedSubviews: [cityLabel.withWidth(70), cityTextField, UIView()])

        emailTextField.text = UserDefaultManager.instance.userEmail
        emailTextField.borderStyle = .roundedRect
        emailTextField.withWidth(UIScreen.main.bounds.width - 70 - 50)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let hStackViewEmail = UIStackView(arrangedSubviews: [emailLabel.withWidth(70), emailTextField, UIView()])

        formContainerStackView.addArrangedSubview(hStackViewImage)
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
    @objc fileprivate func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func doneTapped() {
        if let city = cityTextField.text, let email = emailTextField.text {
            UserDefaultManager.instance.userCity = city
            UserDefaultManager.instance.userEmail = email
        }
         self.dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func imageProfileTapped() {
        showImagePickerControllerActionSheet()
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func showImagePickerControllerActionSheet() {
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showImagePickerController(sourceType: .camera)
            } else {
                self.showAlertOnMainThread(message: "Camera not available.")
            }
        }
        let photoLibaryAction = UIAlertAction(title: "Choose from Library", style: .default) { action in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        AlertService.showAlert(style: .actionSheet, title: "Change Profile Photo", message: nil, actions: [cameraAction, photoLibaryAction, cancelAction], completion: nil)
    }

    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage

        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        imageProfile.image = newImage

        PrintDebug.printDebugGeneral(newImage.size, message: "")

        dismiss(animated: true, completion: nil)
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
