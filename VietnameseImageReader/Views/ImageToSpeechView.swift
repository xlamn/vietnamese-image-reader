//
//  ImageToSpeechView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI
import PhotosUI

struct ImageToSpeechView: View {
    @StateObject private var viewModel = ImageToSpeechViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // MARK: - Image Preview
                ImagePreview(image: viewModel.selectedImage)

                // MARK: - Input Buttons
                HStack(spacing: 16) {
                    Button {
                        viewModel.showCamera = true
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
                            if let data = try? await newItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedItem = nil
                                viewModel.handleImage(uiImage)
                                await viewModel.recognizeText(from: uiImage)
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                }

                // MARK: - Text Recognition Output
                RecognizedTextDisplay(
                    text: viewModel.recognizedText,
                    isProcessing: viewModel.isProcessing
                )

                // MARK: - Speech Output
                if !viewModel.recognizedText.isEmpty {
                    ReadAloudButton(isSpeaking: viewModel.isSpeaking) {
                        if viewModel.isSpeaking {
                            viewModel.stopSpeaking()
                        } else {
                            viewModel.speak()
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Image to Speech")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $viewModel.showCamera) {
                CameraView(viewModel: viewModel)
            }
        }
    }
}

struct ImagePreview: View {
    var image: UIImage?

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
