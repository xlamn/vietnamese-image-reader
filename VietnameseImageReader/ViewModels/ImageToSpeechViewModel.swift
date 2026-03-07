//
//  ImageToSpeechViewModel.swift
//  VietnameseImageReader
//

import SwiftUI
import Combine
import AVFoundation

@MainActor
class ImageToSpeechViewModel: ObservableObject {
    // MARK: - Services
    private let textRecognitionService = TextRecognitionService()
    private let speechService = SpeechService()
    let cameraService = CameraService()

    // MARK: - Published State
    @Published var selectedImage: UIImage?
    @Published var recognizedText: String = ""
    @Published var selectedText: String = ""
    @Published var isProcessing = false
    @Published var isSpeaking = false
    @Published var showCamera = false
    @Published var showCameraPermissionAlert = false

    // MARK: - Camera
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer {
        cameraService.previewLayer
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        speechService.$isSpeaking
            .receive(on: DispatchQueue.main)
            .assign(to: &$isSpeaking)

        cameraService.onPermissionDenied = { [weak self] in
            self?.showCameraPermissionAlert = true
        }
    }

    // MARK: - Image Handling
    func handleImage(_ image: UIImage) {
        selectedImage = image
        recognizedText = ""
        selectedText = ""
    }

    // MARK: - Text Recognition
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

    // MARK: - Speech
    func speak() {
        let textToSpeak = selectedText.isEmpty ? recognizedText : selectedText
        speechService.speak(textToSpeak)
    }

    func stopSpeaking() {
        speechService.stop()
    }

    // MARK: - Camera
    func startCamera() {
        cameraService.startSession()
    }

    func stopCamera() {
        cameraService.stopSession()
    }

    func capturePhoto(completion: @escaping (UIImage) -> Void) {
        cameraService.capturePhoto { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}
