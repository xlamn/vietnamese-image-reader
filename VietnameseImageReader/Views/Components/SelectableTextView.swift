//
//  SelectableTextView.swift
//  VietnameseImageReader
//

import SwiftUI
import UIKit

struct SelectableTextView: UIViewRepresentable {
    let text: String
    @Binding var selectedText: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = .systemFont(ofSize: 17)
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedText: $selectedText)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var selectedText: String

        init(selectedText: Binding<String>) {
            _selectedText = selectedText
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            guard let range = textView.selectedTextRange else {
                selectedText = ""
                return
            }
            selectedText = textView.text(in: range) ?? ""
        }
    }
}
