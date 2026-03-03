//
//  SpeechView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI

struct SpeechView: View {
    @ObservedObject var viewModel: SpeechViewModel
    var text: String

    var body: some View {
        if !text.isEmpty {
            Button {
                if viewModel.isSpeaking {
                    viewModel.stop()
                } else {
                    viewModel.speak(text)
                }
            } label: {
                Label(
                    viewModel.isSpeaking ? "Stop" : "Read Aloud",
                    systemImage: viewModel.isSpeaking ? "stop.fill" : "speaker.wave.2.fill"
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(viewModel.isSpeaking ? .red : .blue)
            .padding(.horizontal)
        }
    }
}
