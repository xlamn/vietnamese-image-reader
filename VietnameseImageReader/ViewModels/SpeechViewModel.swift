//
//  SpeechViewModel.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI

@MainActor
class SpeechViewModel: ObservableObject {
    private let speechService = SpeechService()

    func speak(_ text: String) {
        speechService.speak(text)
    }

    func stop() {
        speechService.stop()
    }
}
