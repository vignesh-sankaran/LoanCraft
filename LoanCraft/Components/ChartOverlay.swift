//
//  ChartOverlay.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 19/3/2025.
//

import SwiftUI

struct ChartOverlay: View {
    var heading: String
    @Binding var text: String
    var body: some View {
        VStack(
            alignment: .center
        ) {
            Text("\(heading):")
                .font(.headline)
            SelectableText(
                text: $text
            )
        }
    }
}
