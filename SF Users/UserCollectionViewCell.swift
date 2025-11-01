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
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var reputationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .regular)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkmark_image"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.addTarget(self,
                         action: #selector(onFollowButtonTap),
                         for: .touchUpInside)
        return button
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
        checkMarkImageView.isHidden = false
    }
    
    func configure(with data: User) {
        isFollowed = data.isFollowed
        nameLabel.text = data.name
        reputationLabel.text = String(data.reputation)
        checkMarkImageView.isHidden = !isFollowed
        if let link = data.profileImage {
            profileImage.downloaded(from: link)
        } else {
            profileImage.image = UIImage(named: "profile_image")
        }
        
        followButton.setTitle(isFollowed ? "Unfollow" : "Follow", for: .normal)
    }
    
    // MARK: - Private
    private func setupCell() {
        
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(reputationLabel)
        contentView.addSubview(followButton)
        profileImage.addSubview(checkMarkImageView)
        
        let labelContainer = UIView()
        labelContainer.addSubview(nameLabel)
        labelContainer.addSubview(reputationLabel)
        contentView.addSubview(labelContainer)
        
        
        [profileImage, nameLabel, reputationLabel, followButton, checkMarkImageView, labelContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            
            checkMarkImageView.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: -4),
            checkMarkImageView.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -4),
            checkMarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkMarkImageView.heightAnchor.constraint(equalTo: checkMarkImageView.widthAnchor),
            
            labelContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelContainer.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            labelContainer.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -12),
            
            nameLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            
            reputationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            reputationLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            reputationLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            reputationLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor),
            
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.widthAnchor.constraint(equalToConstant: 80),
            followButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
    }
    
    @objc
    private func onFollowButtonTap() {
        didTapFollowButton?()
    }
    
}
