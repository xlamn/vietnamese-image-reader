//
//  TextRecognitionView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI

struct TextRecognitionView: View {
    @StateObject private var viewModel = TextRecognitionViewModel()
    @State private var sampleImage = UIImage(named: "vietnamese_sample") // optional local test image

    var body: some View {
        VStack(spacing: 20) {
            if let image = sampleImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)
                    .padding()

                if viewModel.isProcessing {
                    ProgressView("Recognizing text...")
                } else {
                    Button("Recognize Text") {
                        viewModel.recognizeText(from: image)
                    }
                    .buttonStyle(.borderedProminent)
                }

                if !viewModel.recognizedText.isEmpty {
                    ScrollView {
                        Text(viewModel.recognizedText)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }

                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }
            } else {
                Text("No image available for testing.")
            }
        }
        .padding()
        .navigationTitle("OCR Test")
    }
}
