//
//  CustomTextField.swift
//  Website Filter
//
//  Created by Daniel Husiuk on 29.09.2026.
//

import UIKit

final class CustomTextField: UITextField {
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))

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
        let cornerRadius = bounds.height / 2
        layer.cornerRadius = cornerRadius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        blurEffectView.layer.cornerRadius = cornerRadius
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.x -= 8
        return rect
    }
    
    private func setupStyle() {
        autocapitalizationType = .none
        keyboardType = .webSearch
        clearButtonMode = .whileEditing
        
        let leadingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: bounds.height))
        leadingView.backgroundColor = .clear
        leftView = leadingView
        leftViewMode = .always
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        blurEffectView.frame = bounds
        blurEffectView.clipsToBounds = true
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, belowSubview: self)
        
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.15
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(
            systemName: "magnifyingglass",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16,
                weight: .medium
            )
        )?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        let textString = NSAttributedString(
            string: "  Enter website",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.placeholderText
            ]
        )
        
        let placeholder = NSMutableAttributedString()
        placeholder.append(imageString)
        placeholder.append(textString)
        
        attributedPlaceholder = placeholder
    }

}
