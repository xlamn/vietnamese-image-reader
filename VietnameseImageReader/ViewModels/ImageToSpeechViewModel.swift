//
//  ImageToSpeechViewModel.swift
//  VietnameseImageReader
//

import SwiftUI

@MainActor
class ImageToSpeechViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var recognizedText: String = ""
    @Published var showCamera = false
}
