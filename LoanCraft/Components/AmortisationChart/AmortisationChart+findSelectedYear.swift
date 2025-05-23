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

        var minDistance = amortisationSchedule.count
        var index: Int?

        for amortisationScheduleIndex in amortisationSchedule.indices {
            let nthYearDistance = amortisationSchedule[amortisationScheduleIndex].year.distance(
                to: year)
            if abs(nthYearDistance) < minDistance {
                index = amortisationScheduleIndex
                minDistance = abs(nthYearDistance)
            }
        }

        if let index {
            return amortisationSchedule[index].year
        }

        return 1
    }
}
