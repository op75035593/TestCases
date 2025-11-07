//
//  ViewModel.swift
//  TestCases
//
//  Created by LAP1120 on 16/10/25.
//

import Foundation
struct User: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
}


@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func loadUsers() async {
        do {
            users = try await apiService.fetchUsers()
            errorMessage = nil
        } catch {
            users = []
            errorMessage = "Failed to load users"
        }
    }
}



import SwiftUI

import SwiftUI

@MainActor
class UserpostViewModel: ObservableObject {
    @Published var createdUser: Userpost?
    @Published var errorMessage: String?

    private let api = APIServicepost()

    func createNewUser() async {
        do {
            let newUser = Userpost(id: nil, name: "Jane Doe", email: "jane@example.com")
            let result = try await api.createUser(newUser)
            createdUser = result
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}



import Foundation

struct Usergetapi: Codable {
    let id: Int
    let name: String
    let email: String
}

import Foundation

class APIServiceget {
    
    private let urlString: String
    
    // Default initializer with default API URL
    init(urlString: String = "https://jsonplaceholder.typicode.com/users") {
        self.urlString = urlString
    }
    
    func fetchUsers(completion: @escaping (Result<[Usergetapi], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0)))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([Usergetapi].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
