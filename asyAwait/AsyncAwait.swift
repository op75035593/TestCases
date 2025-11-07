//
//  AsyncAwait.swift
//  TestCases
//
//  Created by LAP1120 on 16/10/25.
//

import SwiftUI

struct AsyncAwait: View {
    @StateObject private var viewModel = PostsViewModel()
       
       var body: some View {
           NavigationView {
               Group {
                   if viewModel.isLoading {
                       ProgressView("Loading posts...")
                   } else if let error = viewModel.errorMessage {
                       Text(error)
                           .foregroundColor(.red)
                           .multilineTextAlignment(.center)
                           .padding()
                   } else {
                       List(viewModel.posts) { post in
                           Text(post.title)
                               .padding(.vertical, 4)
                       }
                       .refreshable {
                           await viewModel.fetchPosts()  // <-- async function called here on pull
                       }
                   }
               }
               .navigationTitle("Posts")
               .task {
                   await viewModel.fetchPosts()
               }
               
           }
       }
   }
