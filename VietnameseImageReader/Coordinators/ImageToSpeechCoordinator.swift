//
//  ImageToSpeechCoordinator.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 11.11.25.
//

import SwiftUI
import PhotosUI

@MainActor
class ImageToSpeechCoordinator: ObservableObject {
    @Published var imageVM = ImageSelectionViewModel()
    @Published var textVM = TextRecognitionViewModel()
    @Published var speechVM = SpeechViewModel()
    @Published var cameraVM = CameraViewModel()
    @Published var showCamera = false
    @Published var recognizedText: String = ""

    func handleImage(_ image: UIImage) async {
        imageVM.selectedImage = image
        textVM.reset()
        recognizedText = ""
    }

    func recognizeText(from image: UIImage) async {
        await textVM.recognizeText(from: image)
        recognizedText = textVM.recognizedText
    }
}
