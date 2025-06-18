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
        let data = ChartData()

        #expect(data.principal == 0)
        #expect(data.interest == 0)
    }

    @Test("Total")
    func total() {
        var data = ChartData()
        data.principal = 100_000
        data.interest = 10_000

        #expect(data.total == 110_000)
    }
}
