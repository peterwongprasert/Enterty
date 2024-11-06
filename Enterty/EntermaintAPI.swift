//
//  iOS Networking Layer.swift
//  Enterty
//
//  Created by PandaSan on 11/6/24.
//

import Foundation



struct UserTitle: Codable {
    let titleId: Int
    let userEmail: String
    let startDate: Date?
    let endDate: Date?
    let lastAccessDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case titleId = "title_id"
        case userEmail = "user_email"
        case startDate = "start_date"
        case endDate = "end_date"
        case lastAccessDate = "last_access_date"
    }
}

class EntertainmentAPI {
    static let shared = EntertainmentAPI()
    private let baseURL = "http://localhost:8000"  // Change this to your server URL
    private let jsonDecoder: JSONDecoder
    
    private init() {
        jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    func getAllTitles() async throws -> [Title] {
        let url = URL(string: "\(baseURL)/titles/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try jsonDecoder.decode([Title].self, from: data)
    }
    
    func getTitlesByType(_ type: String)async throws -> [Title] {
        let url = URL(string: "\(baseURL)/titles/\(type)")
        let (data, _) = try await URLSession.shared.data(from: url!)
        return try jsonDecoder.decode([Title].self, from: data)
        
    }
    
    
    func getUserTitles(email: String) async throws -> [Title] {
        let url = URL(string: "\(baseURL)/user-titles/\(email)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try jsonDecoder.decode([Title].self, from: data)
    }
    
    func getTitleDates(titleId: Int, userEmail: String) async throws -> UserTitle {
        let url = URL(string: "\(baseURL)/user-collection/\(userEmail)/\(titleId)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try jsonDecoder.decode(UserTitle.self, from: data)
    }
    
    
    
    
    func addToCollection(titleId: Int, userEmail: String) async throws {
        let url = URL(string: "\(baseURL)/user-collection/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userTitle = UserTitle(titleId: titleId, userEmail: userEmail,
                                  startDate: Date(), endDate: nil, lastAccessDate: Date())
        request.httpBody = try JSONEncoder().encode(userTitle)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    func updateTitleDates(titleId: Int, userEmail: String,
                          startDate: Date?, endDate: Date?, lastAccessDate: Date?) async throws {
        let url = URL(string: "\(baseURL)/user-collection/update")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userTitle = UserTitle(titleId: titleId, userEmail: userEmail,
                                  startDate: startDate, endDate: endDate, lastAccessDate: lastAccessDate)
        request.httpBody = try JSONEncoder().encode(userTitle)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
