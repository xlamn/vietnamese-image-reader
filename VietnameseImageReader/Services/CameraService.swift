//
//  CameraService.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 06.11.25.
//

import AVFoundation
import UIKit

final class CameraService: NSObject {
    private let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var completionHandler: ((UIImage?) -> Void)?
    private let sessionQueue = DispatchQueue(label: "CameraSessionQueue")

    // Public preview layer
    let previewLayer = AVCaptureVideoPreviewLayer()

    override init() {
        super.init()
        previewLayer.videoGravity = .resizeAspectFill
        configureSession()
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(output)
        else {
            print("⚠️ Failed to configure camera session.")
            return
        }

        session.addInput(input)
        session.addOutput(output)
        session.commitConfiguration()

        previewLayer.session = session
    }

    func startSession() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        completionHandler = completion
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error {
            print("❌ Capture error: \(error.localizedDescription)")
            completionHandler?(nil)
            return
        }

        if let data = photo.fileDataRepresentation(),
           let image = UIImage(data: data) {
            completionHandler?(image)
        } else {
            completionHandler?(nil)
        }
    }
}
