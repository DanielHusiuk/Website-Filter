//
//  ButtonModel.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 29.09.2026.
//

import UIKit

enum ButtonType {
    case back
    case forward
    case share
    case filter
    case filterList
}

struct ButtonModel {
    
    struct Button {
        let type: ButtonType
        let image: UIImage?
        let secondaryImage: UIImage?
        let accessibilityIdentifier: String
    }
    
    let toolBarButtons: [Button] = [
        Button(
            type: .back,
            image: UIImage(systemName: "chevron.left"),
            secondaryImage: nil,
            accessibilityIdentifier: "backButton"
        ),
        Button(
            type: .forward,
            image: UIImage(systemName: "chevron.right"),
            secondaryImage: nil,
            accessibilityIdentifier: "forwardButton"
        ),
        Button(
            type: .share,
            image: UIImage(systemName: "square.and.arrow.up"),
            secondaryImage: nil,
            accessibilityIdentifier: "shareButton"
        ),
        Button(
            type: .filter,
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            secondaryImage: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"),
            accessibilityIdentifier: "filterButton"
        ),
        Button(
            type: .filterList,
            image: UIImage(systemName: "list.bullet"),
            secondaryImage: nil,
            accessibilityIdentifier: "filterListButton"
        )
    ]
}
