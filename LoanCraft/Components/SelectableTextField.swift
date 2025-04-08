//
//  SelectableText.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 15/3/2025.
//

import UIKit
import SwiftUI
import SwiftUIIntrospect

struct SelectableTextField: View {
    @State var textWidth: CGFloat = 0
    var onTextWidthChanged: ((CGFloat) -> Void)?
    @State private var textHeight: CGFloat = 0
    @Binding var text: String
    let bold: Bool
    let font: Font
    let textViewDelegate: TextViewDelegate
   
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
        self.onTextWidthChanged = onTextWidthChanged
        textViewDelegate = .init(type: type)
    }

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
            $0.contentInset = .zero
            $0.backgroundColor = .clear
            $0.tintColor = .systemBlue
            $0.delegate = textViewDelegate
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

final class TextViewDelegate: NSObject, UITextViewDelegate {
    @State var analytics = AnalyticsService.instance
    let type: SelectableTextFieldType
    
    init(type: SelectableTextFieldType) {
        self.type = type
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let selectedRange = textView.selectedTextRange, !selectedRange.isEmpty else {
            analytics.track(.textFieldDeselected)
            return
        }
        
        analytics.track(
            .textFieldSelected,
            properties: ["type": type.rawValue]
        )
    }
}
