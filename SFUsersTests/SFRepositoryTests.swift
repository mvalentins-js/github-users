//
//  SFRepositoryTests.swift
//  SFUsers
//
//  Created by Monika Stoyanova on 1.11.25.
//


import XCTest
@testable import SFUsers

final class SFRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    var sut: SFRepository!
    var mockAPI: MockAPIService!
    var mockLocal: MockLocalDataService!
    
    // MARK: - Setup / Teardown
    override func setUp() {
        super.setUp()
        mockAPI = MockAPIService()
        mockLocal = MockLocalDataService()
        sut = SFRepository(apiService: mockAPI, localDataService: mockLocal)
    }
    
    override func tearDown() {
        sut = nil
        mockAPI = nil
        mockLocal = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_fetchUsers_success_mergesFollowedUsersCorrectly() async throws {
        // Given
        let dto = UserDTO(
            badgeCounts: nil,
            accountID: 1,
            isEmployee: false,
            lastModifiedDate: nil,
            lastAccessDate: nil,
            reputationChangeYear: nil,
            reputationChangeQuarter: nil,
            reputationChangeMonth: nil,
            reputationChangeWeek: nil,
            reputationChangeDay: nil,
            reputation: 100,
            creationDate: nil,
            userType: nil,
            userID: 1,
            acceptRate: nil,
            location: nil,
            websiteURL: nil,
            link: nil,
            profileImage: nil,
            displayName: "Monika"
        )
        
        let response = UsersResponseDTO(items: [dto])
        mockAPI.mockResponse = response
        mockLocal.loadResult = ["Monika": true]
        
        // When
        let users = try await sut.fetchUsers()
        
        // Then
        XCTAssertTrue(mockAPI.fetchDataCalled)
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "Monika")
        XCTAssertTrue(users.first?.isFollowed ?? false)
    }
    
    func test_fetchUsers_whenLocalDataEmpty_setsIsFollowedToFalse() async throws {
        // Given
        let dto = UserDTO(
            badgeCounts: nil,
            accountID: 1,
            isEmployee: false,
            lastModifiedDate: nil,
            lastAccessDate: nil,
            reputationChangeYear: nil,
            reputationChangeQuarter: nil,
            reputationChangeMonth: nil,
            reputationChangeWeek: nil,
            reputationChangeDay: nil,
            reputation: 100,
            creationDate: nil,
            userType: nil,
            userID: 1,
            acceptRate: nil,
            location: nil,
            websiteURL: nil,
            link: nil,
            profileImage: nil,
            displayName: "Alex"
        )
        
        mockAPI.mockResponse = UsersResponseDTO(items: [dto])
        mockLocal.loadResult = nil
        
        // When
        let users = try await sut.fetchUsers()
        
        // Then
        XCTAssertEqual(users.count, 1)
        XCTAssertFalse(users.first?.isFollowed ?? true)
    }
    
    func test_saveFollowedUsers_savesToLocalDataService() {
        // Given
        let followed: [String: Bool] = ["Monika": true]
        
        // When
        sut.saveFollowedUsers(users: followed)
        
        // Then
        let saved = mockLocal.savedData["favouriteUsers"] as? [String: Bool]
        XCTAssertEqual(saved?["Monika"], true)
    }
    
    func test_fetchUsers_throwsError_whenAPIFails() async {
        // Given
        mockAPI.shouldThrowError = true
        
        // When / Then
        do {
            _ = try await sut.fetchUsers()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
