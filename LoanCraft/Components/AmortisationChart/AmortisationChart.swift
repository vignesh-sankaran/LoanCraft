//
//  AmortisationChart.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 25/4/2025.
//

import Charts
import SwiftUI

struct AmortisationChart: View {
    @State private var featureFlagService = FeatureFlagService.instance
    @Binding var amortisationSchedule: [AmortisationData]

    var body: some View {
        if featureFlagService.amortisationGraphEnabled {
            Chart {
                ForEach(amortisationSchedule) { amortisationData in
                    LineMark(
                        x: .value("Year", amortisationData.year),
                        y: .value("Remaining", amortisationData.remaining)
                    )
                    RuleMark(x: .value("Year", 1))
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 1))
                }
            }
            .frame(height: 200)
        }
    }
}
