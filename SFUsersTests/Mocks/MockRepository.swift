//
//  MockRepository.swift
//  SF Users
//
//  Created by Monika Stoyanova on 1.11.25.
//


import Foundation
@testable import SFUsers

final class MockRepository: SFRepositoryProtocol {
    
    // MARK: - Dependencies
    var apiService: MockAPIService
    var localDataService: MockLocalDataService
    
    // MARK: - Tracking
    var fetchUsersCalled = false
    var saveFollowedUsersCalled = false
    
    // MARK: - Configurable Test Data
    var mockUsers: [User] = []
    var shouldThrowError = false
    var savedFollowedUsers: [String: Bool] = [:]
    
    // MARK: - Init
    init(
        apiService: MockAPIService = MockAPIService(),
        localDataService: MockLocalDataService = MockLocalDataService()
    ) {
        self.apiService = apiService
        self.localDataService = localDataService
    }
    
    // MARK: - Protocol Conformance
    func fetchUsers() async throws -> [User] {
        fetchUsersCalled = true
        
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return mockUsers
    }
    
    func saveFollowedUsers(users: [String: Bool]) {
        saveFollowedUsersCalled = true
        savedFollowedUsers = users
        mockUsers = mockUsers.map { user in
            var u = user
            u.isFollowed = users[user.name] ?? false
            return u
        }
    }
}
