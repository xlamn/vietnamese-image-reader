//
//  TextRecognitionView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI

struct TextRecognitionView: View {
    @ObservedObject var viewModel: TextRecognitionViewModel

    var body: some View {
        Group {
            if viewModel.isProcessing {
                ProgressView("Recognizing text...")
            } else if !viewModel.recognizedText.isEmpty {
                ScrollView {
                    Text(viewModel.recognizedText)
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
