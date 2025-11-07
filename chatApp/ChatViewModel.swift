//
//  ChatViewModel.swift
//  TestCases
//
//  Created by LAP1120 on 24/10/25.
//

import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentMessage: String = ""
    @Published var isRecording: Bool = false
    @Published var showVideoCall: Bool = false

    private var audioManager = AudioManager()

    func sendText() {
        guard !currentMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let message = Message(type: .text, content: currentMessage, sender: "Me")
        messages.append(message)
        currentMessage = ""
    }

    func startRecording() {
        audioManager.startRecording()
        isRecording = true
    }

    func stopRecording() {
        if let url = audioManager.stopRecording() {
            let message = Message(type: .audio, content: url.absoluteString, sender: "Me")
            messages.append(message)
        }
        isRecording = false
    }

    func playAudio(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        audioManager.playAudio(url: url)
    }

    func startVideoCall() {
        showVideoCall = true
    }
}
