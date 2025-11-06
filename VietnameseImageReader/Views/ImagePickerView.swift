//
//  ImagePickerView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 05.11.25.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @StateObject private var viewModel = ImagePickerViewModel()

    var body: some View {
        VStack(spacing: 20) {
            PhotosPicker(
                selection: $viewModel.photoPicker.selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Choose Photo", systemImage: "photo.on.rectangle")
                    .font(.headline)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
            }

            if let image = viewModel.photoPicker.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(16)
                    .padding()
            } else {
                Text("No image selected yet.")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .navigationTitle("Select Image")
    }
}
