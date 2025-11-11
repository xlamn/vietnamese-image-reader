//
//  ImageToSpeechViewModel.swift
//  VietnameseImageReader
//

import SwiftUI

@MainActor
class ImageSelectionViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showCamera = false
}
