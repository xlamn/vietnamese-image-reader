//
//  ImageToSpeechView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 07.11.25.
//

import SwiftUI
import PhotosUI

struct ImageToSpeechView: View {
    @StateObject private var imageToSpeechVM = ImageToSpeechViewModel()
    @StateObject private var textRecognitionVM = TextRecognitionViewModel()
    @StateObject private var speechVM = SpeechViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                // MARK: - Image Preview
                if let image = imageToSpeechVM.selectedImage {
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

                // MARK: - Input Buttons
                HStack(spacing: 16) {
                    Button {
                        imageToSpeechVM.showCamera = true
                    } label: {
                        Label("Take Photo", systemImage: "camera")
                    }
                    .buttonStyle(.borderedProminent)

                    PhotosPicker("Pick Image", selection: $selectedItem, matching: .images)
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    await handleImage(image)
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                }

                // MARK: - Text Recognition Output
                TextRecognitionView(viewModel: textRecognitionVM)

                // MARK: - Speech Output
                SpeechView(viewModel: speechVM, recognizedText: textRecognitionVM.recognizedText)

                Spacer()
            }
            .padding()
            .navigationTitle("Image → Speech")
            .fullScreenCover(isPresented: $imageToSpeechVM.showCamera) {
                CameraView { image in
                    Task { await handleImage(image) }
                    imageToSpeechVM.showCamera = false
                }
                .ignoresSafeArea()
            }
        }
    }

    // MARK: - Workflow Logic
    private func handleImage(_ image: UIImage) async {
        imageToSpeechVM.selectedImage = image
        textRecognitionVM.reset()
        await textRecognitionVM.recognizeText(from: image)
    }
}


#Preview {
    ImageToSpeechView()
}
