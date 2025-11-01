//
//  APIService.swift
//  SF Users
//
//  Created by Monika Stoyanova on 30.10.25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
}

protocol APIServiceProtocol {
    func fetchData<T: Decodable>(from endpoint: String, responseType: T.Type) async throws -> T
}

final class APIService: APIServiceProtocol {
    
    private let session: URLSession
    private let baseUrl = URL(string:"http://api.stackexchange.com/2.2/")
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(from endpoint: String, responseType: T.Type) async throws -> T {
        
        guard let url = URL(string: endpoint, relativeTo: baseUrl) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let urlResponse = response as? HTTPURLResponse,
                  (200...299).contains(urlResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
}

