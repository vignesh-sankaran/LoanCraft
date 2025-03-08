//
//  ViewModelTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Testing

@testable import LoanCraft

struct ViewModelTests {
    @Test func `init`() {
        let viewModel = ViewModel()

        #expect(viewModel.mortgage == 500_000.0)
        #expect(viewModel.interest == 0.05)
        #expect(viewModel.yearsRemaining == 30)
        #expect(viewModel.repaymentFrequency == .fortnight)
        #expect(viewModel.mortgageRepayment != 0.0)
    }
}
