//
//  ChartDataTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Testing

@testable import LoanCraft

struct ChartDataTests {
    @Test("Init")
    func test_init() {
        let data = ChartData(
            from: .init()
        )

        #expect(data.principal == 500_000)
        #expect(data.interest == 0)
    }

    @Test("Total")
    func total() {
        let data = ChartData(
            from: .init()
        )
        data.principal = 100_000
        data.interest = 10_000

        #expect(data.total == 110_000)
    }
}
