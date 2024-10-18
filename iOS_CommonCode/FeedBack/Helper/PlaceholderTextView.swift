//
//  PlaceholderTextView.swift
//  GPS Map Camera
//
//  Created by iOS on 09/08/24.
//

import UIKit

open class PlaceholderTextView: UITextView {
    
    // Placeholder text property
    var placeholderStr: String? {
        didSet {
            placeholderLabel.text = placeholderStr
        }
    }
    
    // Placeholder label
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray4
        label.numberOfLines = 0
        label.font = self.font
        label.backgroundColor = .clear
        return label
    }()
    
    open override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    open override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceholderLabel()
        textDidChange()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholderLabel()
        textDidChange()
    }
    
    private func setupPlaceholderLabel() {
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        placeholderLabel.text = placeholderStr
    }
    
    func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
