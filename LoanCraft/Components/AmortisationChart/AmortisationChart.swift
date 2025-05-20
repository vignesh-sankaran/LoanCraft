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
                ForEach(
                    Array(
                        amortisationSchedule.enumerated()
                    ),
                    id: \.element.id
                ) { index, data in
                    LineMark(
                        x: .value("Total repayments", data.remainingBalance),
                        y: .value("Month", index)
                    )
                }
            }
            .frame(height: 200)
        }
    }
}
