//
//  LoanCraftView+findSelectedBar.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 9/3/2025.
//

import Charts
import Foundation

extension TotalMortgageChart {
    func findSelectedBar(
        location: CGPoint,
        chartProxy: ChartProxy
    ) -> SelectedBarItem? {
        guard let value = chartProxy.value(atY: location.y) as Decimal? else {
            return nil
        }

        if value <= chartData.principal {
            return .principal
        } else if value <= chartData.total {
            return .interest
        } else {
            return nil
        }
    }
}
