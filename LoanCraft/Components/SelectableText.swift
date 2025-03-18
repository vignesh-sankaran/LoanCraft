//
//  SelectableText.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 15/3/2025.
//

import SwiftUI
import SwiftUIIntrospect

struct SelectableText: View {
    
    @FocusState private var focused: Bool
    @State private var textWidth: CGFloat = 0
    @State private var selection: TextSelection?
    @Binding var text: String
    var body: some View {
        TextEditor(
            text: $text
        )
        .padding(0)
        .introspect(.textEditor, on: .iOS(.v18)) {
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.textContainer.maximumNumberOfLines = 1
            $0.textContainer.lineBreakMode = .byTruncatingTail
            $0.inputAccessoryView = nil
            $0.reloadInputViews()
            $0.textContainerInset = .zero
            $0.backgroundColor = .clear
            $0.tintColor = .systemBlue
            $0.textContainerInset = .zero
        }
        .background(alignment: .leading) {
            Text(text.isEmpty ? " " : text)
                .lineLimit(1)
                .background(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            textWidth = geo.size.width
                        }
                        .onChange(of: text) {
                            textWidth = geo.size.width
                        }
                    }
                )
                .font(.system(size: 17))
                .opacity(0)
        }
        .frame(width: textWidth + 125, height: 25)
    }
}
