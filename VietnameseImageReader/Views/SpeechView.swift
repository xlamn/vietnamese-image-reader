//
//  SpeechView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI

struct SpeechView: View {
    @StateObject private var viewModel = SpeechViewModel()

    var body: some View {
        VStack(spacing: 20) {
            TextEditor(text: $viewModel.textToSpeak)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
                .padding()

            HStack {
                Button(action: { viewModel.speakText() }) {
                    Label("Speak", systemImage: "speaker.wave.2.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)

                Button(action: { viewModel.stopSpeaking() }) {
                    Label("Stop", systemImage: "stop.circle.fill")
                        .font(.headline)
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Text-to-Speech")
    }
}

#Preview {
    SpeechView()
}

