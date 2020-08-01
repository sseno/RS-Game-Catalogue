//
//  UIBarButtonItem+Button.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 07/07/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector?, image: UIImage?, width:CGFloat) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        if let selectorAction = action {
            button.addTarget(target, action: selectorAction, for: .touchUpInside)
        }

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: width).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: width).isActive = true

        return menuBarItem
    }
}
