//
//  ImagePickerViewModel.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 05.11.25.
//

import SwiftUI
import PhotosUI

@MainActor
class ImagePickerViewModel: ObservableObject {
    @Published var photoPicker = PhotoPickerService()
}
