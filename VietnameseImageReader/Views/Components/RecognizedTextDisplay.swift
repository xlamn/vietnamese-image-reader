//
//  RecognizedTextDisplay.swift
//  VietnameseImageReader
//

import SwiftUI

struct RecognizedTextDisplay: View {
    var text: String
    var isProcessing: Bool
    @Binding var selectedText: String

    var body: some View {
        Group {
            if isProcessing {
                ProgressView("Recognizing text...")
            } else if !text.isEmpty {
                SelectableTextView(text: text, selectedText: $selectedText)
                    .frame(maxHeight: 200)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
            } else {
                Text("No text recognized yet.")
                    .foregroundColor(.secondary)
            }
        }
    }
}
