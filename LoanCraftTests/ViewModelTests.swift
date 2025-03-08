//
//  ViewModelTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Foundation
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
        #expect(
            viewModel.chartData.principal == 500_000
        )
        var actualValue = viewModel.chartData.interest
        var actualValueRounded = Decimal()
        NSDecimalRound(
            &actualValueRounded,
            &actualValue,
            2,
            .plain
        )
        let expectedValue: Decimal = 465812.56
        #expect(actualValueRounded == expectedValue)

    }
    
    @Test func calculateMortgageRepayment_zero() {
        let viewModel = ViewModel()
        
        viewModel.mortgage = 0

        #expect(viewModel.mortgageRepayment == 0.0)
    }

    @Test func calculateMortgagePayment_1_000_000() {
        let viewModel = ViewModel()
        
        viewModel.mortgage = 1_000_000
        viewModel.interest = 0.04
        viewModel.yearsRemaining = 25
        viewModel.repaymentFrequency = .month
        
        var actualValue = viewModel.mortgageRepayment
        var actualValueRounded = Decimal()
        NSDecimalRound(
            &actualValueRounded,
            &actualValue,
            2,
            .plain
        )
        let expectedValue: Decimal = 5278.37
        #expect(actualValueRounded == expectedValue)
    }
}
