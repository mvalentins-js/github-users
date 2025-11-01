//
//  StackOverflowUserListView.swift
//  SF Users
//
//  Created by Monika Stoyanova on 30.10.25.
//

import UIKit

class SFUserListViewController: UIViewController {
    // MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
        
    }()
    
    private lazy var emptyView: UIView = {
        let emptyConfiguration = EmptyStateContentConfiguration(
            message: "No users found.\nPlease try again later.",
            image: UIImage(systemName: "person.2.slash")
        )
        let view = emptyConfiguration.makeContentView()
        return view
    }()

    private var viewModel: SFUserViewModelProtocol
    
    // MARK: - Initialization
    init(viewModel: SFUserViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupViewModel()
        loadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Users"
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserCollectionViewCell.self,
                                forCellWithReuseIdentifier: "UserCell")
    }
    
    private func setupViewModel() {
        viewModel.onUsersUpdated = { [weak self] indexPath in
            Task { @MainActor in
                if let indexPath {
                    self?.collectionView.reloadItems(at: [indexPath])
                } else {
                    self?.collectionView.reloadData()
                }
                self?.updateEmptyState()
            }
        }
        
        viewModel.onError = { [weak self] in
            Task { @MainActor in
                self?.updateEmptyState()
            }
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        Task { @MainActor in
            await viewModel.fetchUsers()
        }
        
    }
    
    // MARK: - Error Handling
    private func updateEmptyState() {
        collectionView.backgroundView = viewModel.users.isEmpty ? emptyView : nil
    }
    
}

// MARK: - UICollectionViewDataSource
extension SFUserListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell",
                                                      for: indexPath) as! UserCollectionViewCell
        let user = viewModel.users[indexPath.item]
        cell.configure(with: user)
        
        cell.didTapFollowButton = { @MainActor [weak self] in
            self?.viewModel.toggleFollowState(on: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SFUserListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 100)
    }
}
