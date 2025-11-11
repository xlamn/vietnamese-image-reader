//
//  ImagePickerView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 05.11.25.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    var onImagePicked: (UIImage) -> Void

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showPicker: Bool = false

    var body: some View {
        ZStack {
            // Optional: Background to show while picking
            Color.black.opacity(0.9)
                .ignoresSafeArea()
                .overlay(
                    ProgressView("Opening photo library...")
                        .foregroundColor(.white)
                        .padding()
                )
        }
        .onAppear {
            // open the picker automatically
            showPicker = true
        }
        // Present the system Photos picker
        .photosPicker(
            isPresented: $showPicker,
            selection: $selectedItem,
            matching: .images
        )
        // Handle result
        .onChange(of: selectedItem) { newItem in
            Task {
                guard let item = newItem else {
                    dismiss()
                    return
                }

                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    onImagePicked(uiImage)
                }

                dismiss()
            }
        }
    }
}
