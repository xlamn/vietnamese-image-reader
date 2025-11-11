//
//  TextRecognitionViewModel.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI

@MainActor
class TextRecognitionViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var isProcessing = false

    private let textRecognitionService = TextRecognitionService()

    func recognizeText(from image: UIImage) async {
        isProcessing = true
        defer { isProcessing = false }

        do {
            let text = try await textRecognitionService.recognizeText(from: image)
            recognizedText = text
        } catch {
            recognizedText = "Failed to recognize text."
            print("OCR error: \(error.localizedDescription)")
        }
    }

    func reset() {
        recognizedText = ""
    }
}
