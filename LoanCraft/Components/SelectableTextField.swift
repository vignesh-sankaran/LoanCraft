//
//  SelectableText.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 15/3/2025.
//

import SwiftUI
import SwiftUIIntrospect

struct SelectableTextField: View {
    @State private var analytics = AnalyticsService.instance
    @State private var textWidth: CGFloat = 0
    @State private var textHeight: CGFloat = 0
    @Binding var text: String
    private let bold: Bool
    private let font: Font
    private let type: SelectableTextFieldType

    var onTextWidthChanged: ((CGFloat) -> Void)?

    init(
        bold: Bool = false,
        font: Font = .body,
        text: Binding<String>,
        type: SelectableTextFieldType,
        _ onTextWidthChanged: ((CGFloat) -> Void)? = nil
    ) {
        self.bold = bold
        self.font = font
        self._text = text
        self.type = type
        self.onTextWidthChanged = onTextWidthChanged
    }

    var body: some View {
        TextEditor(
            text: $text
        )
        .padding(0)
        .introspect(.textEditor, on: .iOS(.v26)) {
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.textContainer.maximumNumberOfLines = 1
            $0.textContainer.lineBreakMode = .byTruncatingTail
            $0.inputAccessoryView = nil
            $0.reloadInputViews()
            $0.textContainerInset = .zero
            $0.contentInset = .zero
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
                            textHeight = geo.size.height
                        }
                        .onChange(of: text) {
                            textWidth = geo.size.width
                            textHeight = geo.size.height
                        }
                    }
                )
                .font(font)
                .bold(bold)
                .opacity(0)
        }
        .frame(width: max(125, textWidth + 20), height: textHeight)
        .onChange(of: textWidth) {
            onTextWidthChanged?(textWidth)
        }
    }
}
