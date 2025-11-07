//
//  Message.swift
//  TestCases
//
//  Created by LAP1120 on 24/10/25.
//

import Foundation
import Foundation

enum MessageType: String, Codable {
    case text
    case audio
    case video
}

struct Message: Identifiable, Codable {
    var id: String = UUID().uuidString
    var type: MessageType
    var content: String // For text: message, for audio/video: file URL
    var sender: String
    var timestamp: Date = Date()
}
