//
//  Decimal+rounded.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Foundation

extension Decimal {
    func rounded(
        to places: Int,
        mode: NSDecimalNumber.RoundingMode = .plain
    ) -> Self {
        var input = self
        var result = Decimal()

        NSDecimalRound(
            &result,
            &input,
            places,
            mode
        )

        return result
    }
}
