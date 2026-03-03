//
//  CameraViewModel.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 06.11.25.
//

import SwiftUI
import AVFoundation
import UIKit

@MainActor
class CameraViewModel: ObservableObject {
    private let service = CameraService()
    @Published var previewLayer: AVCaptureVideoPreviewLayer
    @Published var capturedImage: UIImage?
    @Published var showPermissionDeniedAlert = false

    init() {
        self.previewLayer = service.previewLayer
        service.onPermissionDenied = { [weak self] in
            self?.showPermissionDeniedAlert = true
        }
    }

    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
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
