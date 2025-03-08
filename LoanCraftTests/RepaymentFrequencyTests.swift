//
//  RepaymentFrequencyTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Testing

@testable import LoanCraft

struct RepaymentFrequencyTests {
    @Test func repaymentPerYear() {
        #expect(RepaymentFrequency.week.repaymentsPerYear == 52)
        #expect(RepaymentFrequency.fortnight.repaymentsPerYear == 26)
        #expect(RepaymentFrequency.month.repaymentsPerYear == 12)
        #expect(RepaymentFrequency.year.repaymentsPerYear == 1)
    }
}
