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
                        x: .value("Month", amortisationData.month),
                        y: .value("Remaining", amortisationData.remaining)
                    )
                }
            }
            .frame(height: 200)
        }
    }
}
