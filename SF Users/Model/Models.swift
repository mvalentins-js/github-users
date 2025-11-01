//
//  Models.swift
//  SF Users
//
//  Created by Monika Stoyanova on 30.10.25.
//

import Foundation

struct User: Codable, Hashable {
    let name: String
    let reputation: Int
    let profileImage: String?
    var isFollowed: Bool
}

struct UsersResponseDTO: Codable {
    let items: [UserDTO]
}

struct UserDTO: Codable {
    let badgeCounts: BadgeCountsDTO?
    let accountID: Int?
    let isEmployee: Bool?
    let lastModifiedDate: Int?
    let lastAccessDate: Int?
    let reputationChangeYear: Int?
    let reputationChangeQuarter: Int?
    let reputationChangeMonth: Int?
    let reputationChangeWeek: Int?
    let reputationChangeDay: Int?
    let reputation: Int
    let creationDate: Int?
    let userType: String?
    let userID: Int?
    let acceptRate: Int?
    let location: String?
    let websiteURL: String?
    let link: String?
    let profileImage: String?
    let displayName: String
}

extension UserDTO {
    
    func toDomain() -> User {
        User(name: self.displayName,
             reputation: self.reputation,
             profileImage: self.profileImage,
             isFollowed: false)
    }
}

struct BadgeCountsDTO: Codable {
    let bronze: Int
    let silver: Int
    let gold: Int
}
