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
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String? = nil

    private let textRecognitionService = TextRecognitionService()

    func recognizeText(from image: UIImage) {
        isProcessing = true
        Task {
            do {
                let text = try await textRecognitionService.recognizeText(from: image)
                self.recognizedText = text
            } catch {
                self.errorMessage = error.localizedDescription
                print("❌ OCR failed: \(error.localizedDescription)")
            }
            self.isProcessing = false
        }
    }
}
