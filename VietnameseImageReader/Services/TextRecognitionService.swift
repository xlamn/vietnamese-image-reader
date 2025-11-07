//
//  TextRecognitionService.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import UIKit
import Vision

final class TextRecognitionService {
    /// Recognize text from a UIImage using Apple's Vision Framework.
    /// - Parameter image: The UIImage to analyze.
    /// - Returns: The recognized text as a single String.
    func recognizeText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw OCRServiceError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { (request, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
                continuation.resume(returning: recognizedStrings.joined(separator: " "))
            }

            // Configure the request
            request.recognitionLanguages = ["vi"] // 🇻🇳 Vietnamese
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

enum OCRServiceError: Error {
    case invalidImage
}
