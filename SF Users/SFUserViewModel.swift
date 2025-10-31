//
//  SFUserViewModel.swift
//  SF Users
//
//  Created by Monika Stoyanova on 30.10.25.
//

import Foundation

protocol SFUserViewModelProtocol {
    var users: [User] { get }
    var isLoading: Bool { get }
    var onUsersUpdated: ((IndexPath?) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func fetchUsers() async
    func toggleFollowState(on indexPath: IndexPath)
}

class SFUserViewModel: SFUserViewModelProtocol {
    
    enum Constants {
        static let userFriendlyErrorMessage = "Something went wrong, please try again."
    }
    // MARK: - Properties
    private let repository: SFRepositoryProtocol
    
    private(set) var users: [User] = []
    private(set) var isLoading: Bool = false
    private var followStates: [String: Bool] = [:]
    
    var onUsersUpdated: ((IndexPath?) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initialization
    init(repository: SFRepositoryProtocol) {
        self.repository = SFRepository()
    }
    
    // MARK: - Public Methods
    func fetchUsers() async {
        do {
            users = try await repository.fetchUsers()
            users.forEach { followStates[$0.name] = $0.isFollowed }
            onUsersUpdated?(nil)
        } catch {
            onError?(Constants.userFriendlyErrorMessage)
        }
    }
    
    func toggleFollowState(on indexPath: IndexPath) {
        guard users.indices.contains(indexPath.row) else { return }
        
        var user = users[indexPath.row]
        user.isFollowed.toggle()
        users[indexPath.row] = user
        
        followStates[user.name] = user.isFollowed
        
        repository.saveFollowedUsers(users: followStates)
        onUsersUpdated?(indexPath)
    }
    
}

