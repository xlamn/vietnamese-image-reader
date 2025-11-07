//
//  SpeechViewModel.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI

@MainActor
class SpeechViewModel: ObservableObject {
    @Published var textToSpeak: String = ""
    @Published var isSpeaking: Bool = false

    private let speechService = SpeechService()

    func speakText() {
        guard !textToSpeak.isEmpty else { return }
        isSpeaking = true
        speechService.speak(textToSpeak)
    }

    func stopSpeaking() {
        speechService.stop()
        isSpeaking = false
    }
}
