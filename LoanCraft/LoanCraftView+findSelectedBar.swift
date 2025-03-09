//
//  LoanCraftView+findSelectedBar.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 9/3/2025.
//

import Charts
import Foundation

extension LoanCraftView {
    func findSelectedBar(
        location: CGPoint,
        chartProxy: ChartProxy
    ) -> SelectedBarItem? {
        guard let value = chartProxy.value(atY: location.y) as Decimal? else {
            return nil
        }

        if value <= viewModel.chartData.principal {
            return .principal
        } else if value <= viewModel.chartData.total {
            return .interest
        } else {
            return nil
        }
    }
}
