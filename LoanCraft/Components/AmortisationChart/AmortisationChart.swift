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
    @Binding var amortisationSchedule: [AmortisationScheduleData]

    var body: some View {
        if featureFlagService.amortisationGraphEnabled {
            Chart(amortisationSchedule) {
                data in
                ForEach(data.schedule) { amortisationData in
                    LineMark(
                        x: .value("Month", amortisationData.month),
                        y: .value("Remaining", amortisationData.remaining)
                    )
                    .foregroundStyle(by: .value("Type", data.type.rawValue))
                    .symbol(by: .value("Type", data.type.rawValue))
                }
            }
            .frame(height: 200)
        }
    }
}
