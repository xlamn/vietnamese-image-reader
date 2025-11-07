//
//  CameraViewModel.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 06.11.25.
//

import SwiftUI

@MainActor
class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage? = nil
    @Published var isShowingCamera = false

    func handleImage(_ image: UIImage) {
        capturedImage = image
    }
}
