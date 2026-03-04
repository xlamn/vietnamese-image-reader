//
//  ReadAloudButton.swift
//  VietnameseImageReader
//

import SwiftUI

struct ReadAloudButton: View {
    var isSpeaking: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Label(
                isSpeaking ? "Stop" : "Read Aloud",
                systemImage: isSpeaking ? "stop.fill" : "speaker.wave.2.fill"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(isSpeaking ? .red : .blue)
        .padding(.horizontal)
    }
}
