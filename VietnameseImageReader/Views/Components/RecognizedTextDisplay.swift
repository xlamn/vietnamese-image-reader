//
//  RecognizedTextDisplay.swift
//  VietnameseImageReader
//

import SwiftUI

struct RecognizedTextDisplay: View {
    var text: String
    var isProcessing: Bool

    var body: some View {
        Group {
            if isProcessing {
                ProgressView("Recognizing text...")
            } else if !text.isEmpty {
                ScrollView {
                    Text(text)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                }
                .frame(maxHeight: 200)
            } else {
                Text("No text recognized yet.")
                    .foregroundColor(.secondary)
            }
        }
    }
}
