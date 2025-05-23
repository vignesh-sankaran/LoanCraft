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
    @State private var selectedYear: Int = 0

    var body: some View {
        if featureFlagService.amortisationGraphEnabled {
            Chart {
                ForEach(amortisationSchedule) { amortisationData in
                    LineMark(
                        x: .value("Year", amortisationData.year),
                        y: .value("Remaining", amortisationData.remaining)
                    )
                    RuleMark(x: .value("Year", selectedYear))
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 1))
                }
            }
            .chartOverlay { chartProxy in
                GeometryReader { gemoetryProxy in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            SpatialTapGesture()
                                .onEnded { value in
                                    selectedYear = findElement(
                                        location: value.location, chartProxy: chartProxy,
                                        geometryProxy: gemoetryProxy
                                    )
                                }
                                .exclusively(
                                    before: DragGesture()
                                        .onChanged { value in
                                            selectedYear = findElement(
                                                location: value.location, chartProxy: chartProxy,
                                                geometryProxy: gemoetryProxy
                                            )
                                        }
                                )
                        )
                }
            }
            .frame(height: 200)
            .sensoryFeedback(.selection, trigger: selectedYear)
        }
    }
}
