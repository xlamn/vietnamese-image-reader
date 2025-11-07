//
//  CameraView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 06.11.25.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()

    var body: some View {
        VStack(spacing: 20) {
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(16)
                    .padding()
            } else {
                Text("No photo captured yet.")
                    .foregroundColor(.secondary)
            }

            Button {
                viewModel.isShowingCamera = true
            } label: {
                Label("Take Photo", systemImage: "camera")
                    .font(.headline)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
            }
            .fullScreenCover(isPresented: $viewModel.isShowingCamera) {
                CameraService { image in
                    viewModel.handleImage(image)
                }
                .ignoresSafeArea()
            }
        }
        .padding()
        .navigationTitle("Camera")
    }
}

#Preview {
    CameraView()
}
