//
//  SF_UsersTests.swift
//  SF UsersTests
//
//  Created by Monika Stoyanova on 30.10.25.
//

import XCTest
@testable import SFUsers

final class SFUsersTests: XCTestCase {
    
    var sut: SFUserViewModel!
    var mockRepo: MockRepository!
    
    // MARK: - Setup / Teardown
    override func setUp() {
        super.setUp()
        mockRepo = MockRepository()
        sut = SFUserViewModel(repository: mockRepo)
    }
    
    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_fetchUsers_success_updatesUsersAndCallsOnUsersUpdated() async {
        // Given
        mockRepo.mockUsers = [
            User(name: "Monika", reputation: 1200, profileImage: nil, isFollowed: false),
            User(name: "Alex", reputation: 800, profileImage: nil, isFollowed: true)
        ]
        
        let expectation = XCTestExpectation(description: "onUsersUpdated called")
        sut.onUsersUpdated = { _ in
            expectation.fulfill()
        }
        
        // When
        await sut.fetchUsers()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(mockRepo.fetchUsersCalled)
        XCTAssertEqual(sut.users.count, 2)
        XCTAssertEqual(sut.users.first?.name, "Monika")
    }
    
    func test_fetchUsers_failure_callsOnErrorAndShouldShowAlert() async {
        // Given
        mockRepo.shouldThrowError = true
        
        let expectation1 = XCTestExpectation(description: "onError called")
        let expectation2 = XCTestExpectation(description: "shouldShowAlert called")
        sut.onError = { expectation1.fulfill()}
        sut.shouldShowAlert = { expectation2.fulfill() }
        
        // When
        await sut.fetchUsers()
        
        // Then
        await fulfillment(of: [expectation1, expectation2], timeout: 1.0)
    }
    
    func test_toggleFollowState_togglesAndSavesFollowedUser() async {
        // Given
        let mockUsers = [
            User(name: "Monika", reputation: 100, profileImage: nil, isFollowed: false)
        ]
        mockRepo.mockUsers = mockUsers
        
        await sut.fetchUsers()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let expectation = XCTestExpectation(description: "onUsersUpdated called")
        sut.onUsersUpdated = { _ in
            expectation.fulfill()
        }
        
        // When
        sut.toggleFollowState(on: indexPath)
        
        // Then
        XCTAssertTrue(sut.users[0].isFollowed)
        XCTAssertTrue(mockRepo.saveFollowedUsersCalled)
        XCTAssertEqual(mockRepo.mockUsers[indexPath.row].isFollowed, true)
    }
    
    func test_toggleFollowState_withInvalidIndex_doesNotCrash() {
        // Given
        mockRepo.mockUsers = []
        
        // When
        sut.toggleFollowState(on: IndexPath(row: 10, section: 0))
        
        // Then
        XCTAssertFalse(mockRepo.saveFollowedUsersCalled)
    }
}
