//
//  EmptyStateContentConfiguration.swift
//  SFUsers
//
//  Created by Monika Stoyanova on 1.11.25.
//

import UIKit

struct EmptyStateContentConfiguration: UIContentConfiguration {
    var message: String
    var image: UIImage?
    
    func makeContentView() -> UIView & UIContentView {
        EmptyStateContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> EmptyStateContentConfiguration {
        self
    }
}

final class EmptyStateContentView: UIView, UIContentView {
    // MARK: Private properties
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    
    var configuration: UIContentConfiguration {
        didSet { apply(configuration: configuration) }
    }
    
    // MARK: - Init
    init(configuration: EmptyStateContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupView()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    private func setupView() {
        backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        
        addSubview(imageView)
        addSubview(messageLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func apply(configuration: UIContentConfiguration) {
        guard let config = configuration as? EmptyStateContentConfiguration else { return }
        imageView.image = config.image ?? UIImage(systemName: "person.2.slash")
        messageLabel.text = config.message
    }
    
}
