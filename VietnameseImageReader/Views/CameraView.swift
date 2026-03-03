//
//  CameraView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 06.11.25.
//

import SwiftUI
import AVFoundation

class PreviewView: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer?

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.backgroundColor = .black
        if let previewLayer = previewLayer {
            view.previewLayer = previewLayer
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.previewLayer?.frame = uiView.bounds
    }
}

struct CameraView: View {
    @ObservedObject var viewModel: CameraViewModel
    var onImageCaptured: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    private var topSafeArea: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 59
    }

    var body: some View {
        CameraPreviewView(previewLayer: viewModel.previewLayer)
            .ignoresSafeArea()
            .onAppear { viewModel.startSession() }
            .onDisappear { viewModel.stopSession() }
            .overlay {
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, topSafeArea)

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
                    }
                    .padding(.bottom, 40)
                }
            }
        .alert("Camera Access Required", isPresented: $viewModel.showPermissionDeniedAlert) {
            Button("Open Settings") {
                viewModel.openSettings()
                dismiss()
            }
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Please enable camera access in Settings to take photos.")
        }
    }
}
