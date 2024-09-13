//
//  CustomActionSheetView.swift
//  GPS Map Camera
//
//  Created by iOS on 09/08/24.
//

import UIKit

class CustomActionSheetView: UIView {

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let mainStackView = UIStackView()
    private let titleMessageStackView = UIStackView()
    private var options = [String]()

    var completion: ((String) -> Void)?

    init(title: String, message: String, options: [String]) {
        super.init(frame: .zero)
        self.options = options
        setupView(title: title, message: message, options: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(title: String, message: String, options: [String]) {
        // Style the view
        backgroundColor = .white
        layer.cornerRadius = 15
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10

        // Configure titleLabel
        titleLabel.text = title.localized()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = UIColor.gray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        // Configure messageLabel
        messageLabel.text = message.localized()
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.textColor = UIColor.gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        // Configure titleMessageStackView
        titleMessageStackView.axis = .vertical
        titleMessageStackView.spacing = 4
        titleMessageStackView.alignment = .center
        titleMessageStackView.addArrangedSubview(titleLabel)
        titleMessageStackView.addArrangedSubview(messageLabel)
        titleMessageStackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        titleMessageStackView.isLayoutMarginsRelativeArrangement = true

        // Configure mainStackView
        mainStackView.axis = .vertical
        mainStackView.spacing = 0

        // Add titleMessageStackView to mainStackView
        mainStackView.addArrangedSubview(titleMessageStackView)
        addSeparator()

        for (index,option) in options.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option.localized(), for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.tag = index
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            mainStackView.addArrangedSubview(button)
            addSeparator()
        }

        // Add mainStackView to the view
        addSubview(mainStackView)

        // Set constraints for mainStackView
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        mainStackView.addArrangedSubview(separator)
    }

    @objc private func optionSelected(_ sender: UIButton) {
        completion?(self.options[sender.tag])
    }
}
