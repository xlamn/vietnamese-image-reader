//
//  SpeechViewModel.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI
import Combine

@MainActor
class SpeechViewModel: ObservableObject {
    private let speechService = SpeechService()
    private var cancellables = Set<AnyCancellable>()

    @Published var isSpeaking = false

    init() {
        speechService.$isSpeaking
            .receive(on: DispatchQueue.main)
            .assign(to: &$isSpeaking)
    }

    func speak(_ text: String) {
        speechService.speak(text)
    }

    func stop() {
        speechService.stop()
    }
}
