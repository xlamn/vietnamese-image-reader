//
//  PhotosPickerService.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 05.11.25.
//

import SwiftUI
import PhotosUI

@MainActor
class PhotoPickerService: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task { await loadImage(from: selectedItem) }
        }
    }

    // MARK: - Load Image
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }

        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.selectedImage = uiImage
            } else {
                print("⚠️ Could not load image data.")
            }
        } catch {
            print("❌ Error loading image: \(error.localizedDescription)")
        }
    }
}
