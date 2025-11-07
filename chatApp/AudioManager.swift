//
//  AudioManager.swift
//  TestCases
//
//  Created by LAP1120 on 24/10/25.
//

import Foundation

import AVFoundation
import SwiftUI

class AudioManager: NSObject, ObservableObject, AVAudioRecorderDelegate {
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?

    func startRecording() {
        let path = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        recorder = try? AVAudioRecorder(url: path, settings: settings)
        recorder?.record()
    }

    func stopRecording() -> URL? {
        recorder?.stop()
        let url = recorder?.url
        recorder = nil
        return url
    }

    func playAudio(url: URL) {
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}
