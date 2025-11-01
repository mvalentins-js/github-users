//
//  MockAPIService.swift
//  SFUsers
//
//  Created by Monika Stoyanova on 1.11.25.
//

import Foundation
@testable import SFUsers

final class MockAPIService: APIServiceProtocol {
    
    var fetchDataCalled = false
    var shouldThrowError = false
    var mockResponse: UsersResponseDTO?
    
    func fetchData<T>(from endpoint: String, responseType: T.Type) async throws -> T where T : Decodable {
        fetchDataCalled = true
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        guard let response = mockResponse as? T else {
            throw URLError(.cannotDecodeRawData)
        }
        return response
    }
}

final class MockLocalDataService: LocalDataServiceProtocol {
    
    var savedData: [String: Any] = [:]
    var loadResult: Any?
    
    func save<T: Codable>(data: T, key: String) {
        savedData[key] = data
    }
    
    func loadData<T: Codable>(for key: String, type: T.Type) -> T? {
        return loadResult as? T
    }
}
