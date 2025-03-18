//
//  SelectableText.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 15/3/2025.
//

import SwiftUI
import SwiftUIIntrospect

struct SelectableText: View {
    @State private var textWidth: CGFloat = 0
    @State var bold: Bool = false
    @State var font: Font = .body
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
        }
        .bold(bold)
        .font(font)
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
                .font(font)
                .bold(bold)
                .opacity(0)
        }
        .frame(width: max(125, textWidth + 20), height: 40)
    }
}
