//
//  ChatView.swift
//  TestCases
//
//  Created by LAP1120 on 24/10/25.
//

import SwiftUI

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, viewModel: viewModel)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }

            Divider()

            HStack {
                TextField("Type message...", text: $viewModel.currentMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: viewModel.sendText) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }

                if viewModel.isRecording {
                    Button(action: viewModel.stopRecording) {
                        Image(systemName: "stop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                } else {
                    Button(action: viewModel.startRecording) {
                        Image(systemName: "mic.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }

                Button(action: viewModel.startVideoCall) {
                    Image(systemName: "video.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.showVideoCall) {
            VideoCallView()
        }
    }
}

struct MessageBubble: View {
    let message: Message
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        HStack {
            if message.sender == "Me" { Spacer() }

            VStack(alignment: .leading) {
                switch message.type {
                case .text:
                    Text(message.content)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                case .audio:
                    Button(action: {
                        viewModel.playAudio(message.content)
                    }) {
                        Label("Play Audio", systemImage: "play.circle.fill")
                            .padding()
                            .background(Color.orange.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                case .video:
                    Text("📹 Video message (coming soon)")
                        .padding()
                        .background(Color.purple.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            if message.sender != "Me" { Spacer() }
        }
        .padding(.horizontal)
    }
}
