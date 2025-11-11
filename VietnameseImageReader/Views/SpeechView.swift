//
//  SpeechView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI

struct SpeechView: View {
    @ObservedObject var viewModel: SpeechViewModel
    var recognizedText: String

    var body: some View {
        if !recognizedText.isEmpty {
            Button {
                viewModel.speak(recognizedText)
            } label: {
                Label("Read Aloud", systemImage: "speaker.wave.2.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
    }
}
