//
//  AsyncAwaitViewModel.swift
//  TestCases
//
//  Created by LAP1120 on 16/10/25.
//

import Foundation


struct post:Codable, Identifiable {
    let userId: Int
       let id: Int
       let title: String
       let body: String
}

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts:[post] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    func fetchPosts() async  {
        isLoading = true
        errorMessage = nil
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let decodePosts = try JSONDecoder().decode([post].self, from: data)
          
              posts = decodePosts
                isLoading = false
            print(posts)
           
        } catch {
                    errorMessage = error.localizedDescription
                    print("❌ Error:", error)
            isLoading = false
                }
        
        
    }
    
}
