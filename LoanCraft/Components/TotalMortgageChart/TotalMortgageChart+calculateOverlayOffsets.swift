//
//  LoanCraftView+calculateOverlayOffsets.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 9/3/2025.
//

import Charts
import Foundation

extension TotalMortgageChart {
    func calculateOverlayOffsets(
        from chartProxy: ChartProxy
    ) -> (x: CGFloat, y: CGFloat) {
        let xOffset = (chartProxy.plotSize.width / 2) - (self.overlayWidth / 2)
        let yOffset: CGFloat =
            if selectedBar == .principal {
                chartProxy.position(
                    forY: viewModel.principal) ?? 0
            } else {
                chartProxy.position(
                    forY: viewModel.total + 10) ?? 0
            }
        return (x: xOffset, y: yOffset)
    }
}
