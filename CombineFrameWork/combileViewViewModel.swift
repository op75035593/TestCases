//
//  combileViewViewModel.swift
//  TestCases
//
//  Created by LAP1120 on 17/10/25.
//

import SwiftUI

import Foundation
import Combine

import Foundation

struct Userget: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
}


import Foundation
import Combine

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [Userget] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        NetworkService.fetchData(from: url)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to load users: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (users: [Userget]) in
                self?.users = users
            }
            .store(in: &cancellables)
    }
}



class NetworkService {
    static func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
