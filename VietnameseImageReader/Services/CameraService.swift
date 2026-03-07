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
    private var isConfigured = false
    private var currentDevice: AVCaptureDevice?
    var onPermissionDenied: (() -> Void)?

    // Public preview layer
    let previewLayer: AVCaptureVideoPreviewLayer

    // Zoom properties
    var minZoomFactor: CGFloat {
        currentDevice?.minAvailableVideoZoomFactor ?? 1.0
    }

    var maxZoomFactor: CGFloat {
        min(currentDevice?.maxAvailableVideoZoomFactor ?? 5.0, 10.0)
    }

    var currentZoomFactor: CGFloat {
        currentDevice?.videoZoomFactor ?? 1.0
    }

    override init() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init()
        previewLayer.videoGravity = .resizeAspectFill
    }

    private func configureSession() {
        // Must be called on sessionQueue
        guard !isConfigured else { return }

        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(output)
        else {
            session.commitConfiguration()
            print("⚠️ Failed to configure camera session.")
            return
        }

        session.addInput(input)
        session.addOutput(output)
        session.commitConfiguration()
        currentDevice = device
        isConfigured = true
    }

    func setZoom(_ factor: CGFloat) {
        sessionQueue.async {
            guard let device = self.currentDevice else { return }
            let clampedFactor = max(self.minZoomFactor, min(factor, self.maxZoomFactor))

            do {
                try device.lockForConfiguration()
                device.videoZoomFactor = clampedFactor
                device.unlockForConfiguration()
            } catch {
                print("⚠️ Failed to set zoom: \(error.localizedDescription)")
            }
        }
    }

    func startSession() {
        // Check permission on main thread first
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            sessionQueue.async {
                self.configureSession()
                if !self.session.isRunning {
                    self.session.startRunning()
                }
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    self.sessionQueue.async {
                        self.configureSession()
                        if !self.session.isRunning {
                            self.session.startRunning()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.onPermissionDenied?()
                    }
                }
            }
        case .denied, .restricted:
            print("⚠️ Camera access denied or restricted.")
            DispatchQueue.main.async {
                self.onPermissionDenied?()
            }
        @unknown default:
            break
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
        sessionQueue.async {
            self.completionHandler = completion
            let settings = AVCapturePhotoSettings()
            self.output.capturePhoto(with: settings, delegate: self)
        }
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
