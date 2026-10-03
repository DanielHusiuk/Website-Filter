//
//  CustomButton.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 29.09.2026.
//

import UIKit

final class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        tintColor = .tintColor
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
