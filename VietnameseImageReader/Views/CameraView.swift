//
//  CameraView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 06.11.25.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        if let previewLayer = previewLayer {
            previewLayer.frame = UIScreen.main.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = previewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    var onImageCaptured: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            CameraPreviewView(previewLayer: viewModel.previewLayer)
                .ignoresSafeArea()
                .onAppear { viewModel.startSession() }
                .onDisappear { viewModel.stopSession() }

            VStack {
                Spacer()
                Button {
                    viewModel.capturePhoto { image in
                        onImageCaptured(image)
                        dismiss()
                    }
                } label: {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 4)
                        .frame(width: 80, height: 80)
                        .overlay(Circle().fill(Color.white.opacity(0.2)))
                        .padding(.bottom, 40)
                }
            }
        }
    }
}
