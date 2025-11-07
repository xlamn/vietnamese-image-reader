//
//  SpeechService.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import AVFoundation

final class SpeechService: NSObject, ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// Speak a given text string in Vietnamese.
    func speak(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "vi-VN")   // 🇻🇳 Vietnamese
        utterance.rate = 0.48                                         // natural speed
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        synthesizer.speak(utterance)
    }

    /// Stop any ongoing speech.
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

// MARK: - Delegate (optional for state tracking)
extension SpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("✅ Finished speaking.")
    }
}
