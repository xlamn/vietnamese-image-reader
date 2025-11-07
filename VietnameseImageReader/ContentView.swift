//
//  ContentView.swift
//  VietnameseImageReader
//
//  Created by Lam Nguyen on 04.11.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ImagePickerView()
            CameraView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
