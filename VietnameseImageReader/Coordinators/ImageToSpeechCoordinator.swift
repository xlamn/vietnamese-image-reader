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
    
    func handleImage(_ image: UIImage) async {
        imageVM.selectedImage = image
        textVM.reset()
    }
    
    func recognizeText(from image: UIImage) async {
        await textVM.recognizeText(from: image)
    }
}
