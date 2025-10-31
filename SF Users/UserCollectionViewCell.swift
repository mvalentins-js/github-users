//
//  UserCollectionViewCell.swift
//  SF Users
//
//  Created by Monika Stoyanova on 30.10.25.
//

import UIKit

// MARK: - UICollectionViewCell
class UserCollectionViewCell: UICollectionViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var reputationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.addTarget(self,
                         action: #selector(onFollowButtonTap),
                         for: .touchUpInside)
        button.layer.cornerRadius = 3
        return button
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private var isFollowed = false
    
    var didTapFollowButton: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        didTapFollowButton = nil
        isFollowed = false
    }
    
    func configure(with data: User) {
        isFollowed = data.isFollowed
        nameLabel.text = data.name
        reputationLabel.text = String(data.reputation)
        if let link = data.profileImage {
            profileImage.downloaded(from: link)
        } else {
            profileImage.image = UIImage(named: "profile_image")
        }
        
        followButton.setTitle(isFollowed ? "Unfollow" : "Follow", for: .normal)
    }
    
    // MARK: - Private
    private func setupCell() {
        [profileImage, nameLabel, reputationLabel, followButton].forEach {
            containerView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc
    private func onFollowButtonTap() {
        didTapFollowButton?()
    }
    
}
