//
//  SFRepository.swift
//  SF Users
//
//  Created by Monika Stoyanova on 30.10.25.
//

import Foundation

protocol LocalDataServiceProtocol {
    func save<T: Codable>(data: T, key: String)
    func loadData<T: Codable>(for key: String, type: T.Type) -> T?
}

class LocalDataService: LocalDataServiceProtocol {
    
    func save<T: Codable>(data: T, key: String) {
        if let data = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadData<T: Codable>(for key: String, type: T.Type) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let users = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return users
    }
    
}

protocol SFRepositoryProtocol {
    func fetchUsers() async throws -> [User]
    func saveFollowedUsers(users: [String: Bool])
}

class SFRepository: SFRepositoryProtocol {
    // MARK: - Properties
    private let apiService: APIServiceProtocol
    private let localDataService: LocalDataServiceProtocol
    private let endPoint = "users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow" //TODO: fix
    private let followedUsersKey: String = "favouriteUsers"
    
    // MARK: - Init
    init(apiService: APIServiceProtocol = APIService(),
         localDataService: LocalDataServiceProtocol = LocalDataService()) {
        self.apiService = apiService
        self.localDataService = localDataService
    }
    
    // MARK: - Public
    func fetchUsers() async throws -> [User] {
        let response = try await apiService.fetchData(from: endPoint,
                                                      responseType: UsersResponseDTO.self)
        let remote = response.items.map{ $0.toDomain() }
        let followed = localDataService.loadData(for: followedUsersKey,
                                                 type: [String:Bool].self)
        
        print("@@ followed fetched: \(followed)")
        
        return mergeUsers(remote: remote, local: followed)
    }
    
    func saveFollowedUsers(users: [String:Bool]) {
        localDataService.save(data: users, key: followedUsersKey)
        print("@@ Saved \(users)")
    }
    
    // MARK: - Private
    private func mergeUsers(remote: [User], local: [String: Bool]?) -> [User] {
        remote.map { user in
            var u = user
            u.isFollowed = local?[user.name] ?? false
            return u
        }
    }

}
