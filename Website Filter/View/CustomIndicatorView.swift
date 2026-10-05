//
//  CustomIndicatorView.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 02.10.2026.
//

import UIKit

final class CustomIndicatorView: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: .medium)
        setupStyle()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        
        hidesWhenStopped = true
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }
}
