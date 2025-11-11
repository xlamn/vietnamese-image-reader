//
//  CameraViewModel.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 06.11.25.
//

import SwiftUI
import AVFoundation

@MainActor
class CameraViewModel: ObservableObject {
    private let service = CameraService()
    @Published var previewLayer: AVCaptureVideoPreviewLayer
    @Published var capturedImage: UIImage?

    init() {
        self.previewLayer = service.previewLayer
    }

    func startSession() {
        service.startSession()
    }

    func stopSession() {
        service.stopSession()
    }

    func capturePhoto(completion: @escaping (UIImage) -> Void) {
        service.capturePhoto { [weak self] image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self?.capturedImage = image
                completion(image)
            }
        }
    }
}
