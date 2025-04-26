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

    var body: some View {
        if featureFlagService.amortisationGraphEnabled {
            Chart {
                LineMark(
                    x: .value("", 1),
                    y: .value("", 2)
                )
            }
        }
    }
}
