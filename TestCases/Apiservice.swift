//
//  Apiservice.swift
//  TestCases
//
//  Created by LAP1120 on 16/10/25.
//

import Foundation

import Foundation

protocol APIServiceProtocol {
    func fetchUsers() async throws -> [User]
}

final class APIService: APIServiceProtocol {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([User].self, from: data)
    }
}



import Foundation

import Foundation

struct Userpost: Codable, Equatable, Identifiable {
    let id: Int?
    let name: String
    let email: String
}

final class APIServicepost {
    private let baseURL = URL(string: "https://api.example.com")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func createUser(_ user: Userpost) async throws -> Userpost {
        let endpoint = baseURL.appendingPathComponent("/users")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Userpost.self, from: data)
    }
}
