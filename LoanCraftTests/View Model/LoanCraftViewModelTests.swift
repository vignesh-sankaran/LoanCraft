//
//  ViewModelTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Foundation
import Testing

@testable import LoanCraft

struct LoanCraftViewModelTests {
    @Test("init")
    func `init`() {
        let viewModel = LoanCraftViewModel()

        #expect(viewModel.mortgage == 500_000.0)
        #expect(viewModel.interest == 0.05)
        #expect(viewModel.yearsRemaining == 30)
        #expect(viewModel.repaymentFrequency == .fortnight)
        #expect(viewModel.mortgageRepayment == 0)
        #expect(viewModel.totalMortgage == 0)
        #expect(viewModel.totalInterest == 0)
    }

    @Test("Mortgage didSet")
    func mortgage_didSet() throws {
        let viewModel = LoanCraftViewModel()

        try #require(viewModel.mortgageRepayment == 0)

        viewModel.mortgage = 350_000

        #expect(viewModel.mortgageRepayment.rounded(to: 2) == 866.75)
        #expect(viewModel.totalInterest.rounded(to: 2) == 326_068.79)
    }

    @Test("Interest didSet")
    func interest_didSet() throws {
        let viewModel = LoanCraftViewModel()
        try #require(viewModel.mortgageRepayment == 0)

        viewModel.interest = 0.025

        #expect(viewModel.mortgageRepayment.rounded(to: 2) == 911.47)
        #expect(viewModel.totalInterest.rounded(to: 2) == 210_950.07)
    }

    @Test("yearsRemaining didSet")
    func yearsRemaining_didSet() throws {
        let viewModel = LoanCraftViewModel()
        try #require(viewModel.mortgageRepayment == 0)

        viewModel.yearsRemaining = 25

        #expect(viewModel.mortgageRepayment.rounded(to: 2) == 1348.30)
        #expect(viewModel.totalInterest.rounded(to: 2) == 376_392.14)
    }

    @Test("repaymentFrequency didSet")
    func repaymentFrequency_didSet() throws {
        let viewModel = LoanCraftViewModel()
        try #require(viewModel.mortgageRepayment == 0)

        viewModel.repaymentFrequency = .month

        #expect(viewModel.mortgageRepayment.rounded(to: 2) == 2684.11)
        #expect(viewModel.totalInterest.rounded(to: 2) == 466_278.92)
    }

    // MARK: - Specific values

    @Test("calculateMortgagePayment 0")
    func calculateMortgageRepayment_zero() {
        let viewModel = LoanCraftViewModel()

        viewModel.mortgage = 0

        #expect(viewModel.mortgageRepayment == 0.0)
    }

    @Test("calculateMortgagePayment 1,000,000")
    func calculateMortgagePayment_1_000_000() {
        let viewModel = LoanCraftViewModel()

        viewModel.mortgage = 1_000_000
        viewModel.interest = 0.04
        viewModel.yearsRemaining = 25
        viewModel.repaymentFrequency = .month

        #expect(viewModel.mortgageRepayment.rounded(to: 2) == 5278.37)
    }
}
