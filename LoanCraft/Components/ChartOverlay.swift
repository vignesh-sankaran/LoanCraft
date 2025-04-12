//
//  ChartOverlay.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 19/3/2025.
//

import SwiftUI

struct ChartOverlay: View {
    let heading: String
    let text: String
    let type: SelectableTextFieldType
    @Binding var textWidth: CGFloat

    init(
        chartData: ChartData,
        selectedBar: SelectedBarItem,
        textWidth: Binding<CGFloat>
    ) {
        _textWidth = textWidth
        if selectedBar == .principal {
            heading = "Principal:"
            text = chartData.formattedPrincipal
            type = .principal
        } else {
            heading = "Interest:"
            text = chartData.formattedInterest
            type = .interest
        }
    }

    var body: some View {
        VStack(
            alignment: .center,
            spacing: 4
        ) {
            Text(heading)
                .font(.headline)
            SelectableTextField(
                text: .constant(text),
                type: type
            ) { newValue in
                textWidth = newValue
            }
            .multilineTextAlignment(.center)
        }
        .padding(.top, 2)
        .padding(.bottom, 4)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.background)
                RoundedRectangle(cornerRadius: 8)
                    .fill(.quaternary.opacity(0.7))
            }
            .padding(.horizontal, -8)
            .padding(.vertical, -4)
        }
    }
}
