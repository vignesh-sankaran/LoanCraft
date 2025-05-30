//
//  AmortisationChart+findSelectedYear.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 23/5/2025.
//

import Charts
import Foundation
import SwiftUICore

extension AmortisationChart {
    func findElement(
        location: CGPoint,
        chartProxy: ChartProxy,
        geometryProxy: GeometryProxy
    ) -> Int {
        guard let plotFrame = chartProxy.plotFrame else { return 1 }

        let relativeXPosition = location.x - geometryProxy[plotFrame].origin.x

        guard let year = chartProxy.value(atX: relativeXPosition) as Int? else {
            return 1
        }

        var minDistance = viewModel.schedule.count
        var index: Int?

        for amortisationScheduleIndex in viewModel.schedule.indices {
            let nthYearDistance = viewModel.schedule[amortisationScheduleIndex].year.distance(
                to: year)
            if abs(nthYearDistance) < minDistance {
                index = amortisationScheduleIndex
                minDistance = abs(nthYearDistance)
            }
        }

        if let index {
            return viewModel.schedule[index].year
        }

        return 1
    }
}
