//
//  ChartDataTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Testing

@testable import LoanCraft

struct ChartDataTests {
    @Test("Total")
    func total() {
        let data = ChartData(
            principal: 100_000,
            interest: 10_000
        )

        #expect(data.total == 110_000)
    }
}
