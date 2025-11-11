//
//  ImageToSpeechView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI
import PhotosUI

struct ImageToSpeechView: View {
    @StateObject private var coordinator = ImageToSpeechCoordinator()
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // MARK: - Image Preview
                ImagePreview(image: $coordinator.imageVM.selectedImage)

                // MARK: - Input Buttons
                HStack(spacing: 16) {
                    Button {
                        coordinator.imageVM.showCamera = true
                    } label: {
                        Label("Take Photo", systemImage: "camera")
                    }
                    .buttonStyle(.borderedProminent)

                    PhotosPicker(
                        "Pick Image",
                        selection: $selectedItem,
                        matching: .images
                    )
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            guard let newItem else { return }
                            do {
                                if let data = try await newItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedItem = nil
                                    await coordinator.handleImage(uiImage)
                                    await coordinator.recognizeText(from: uiImage)
                                }
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                }

                // MARK: - Text Recognition Output
                TextRecognitionView(viewModel: coordinator.textVM)

                // MARK: - Speech Output
                SpeechView(viewModel: coordinator.speechVM,
                           recognizedText: coordinator.textVM.recognizedText)

                Spacer()
            }
            .padding()
            .navigationTitle("Image → Speech")
            .fullScreenCover(isPresented: $coordinator.imageVM.showCamera) {
                CameraView { image in
                    Task { await coordinator.handleImage(image) }
                    coordinator.imageVM.showCamera = false
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct ImagePreview: View {
    @Binding var image: UIImage?

    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .cornerRadius(16)
                .padding()
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .overlay(Text("No image selected"))
                .frame(height: 250)
                .padding()
        }
    }
}



#Preview {
    ImageToSpeechView()
}
