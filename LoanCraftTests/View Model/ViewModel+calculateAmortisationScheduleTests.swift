//
//  ViewModel+calculateAmortisationScheduleTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 30/4/2025.
//

import Testing

@testable import LoanCraft

struct ViewModel_calculateAmortisationScheduleTests {
    @Test("250k")
    func test() {
        let viewModel = ViewModel()

        viewModel.mortgage = 250_000
        viewModel.interest = 0.05
        viewModel.yearsRemaining = 30

        #expect(viewModel.amortisationSchedule.first?.remaining == 250_000)
        #expect(viewModel.amortisationSchedule.last?.remaining == 0)
        #expect(viewModel.amortisationSchedule.count == 31)
    }

    @Test("0k")
    func test_0() {
        let viewModel = ViewModel()

        viewModel.mortgage = 0
        viewModel.yearsRemaining = 0

        #expect(
            viewModel.amortisationSchedule.first?.year == 0
        )
        #expect(
            viewModel.amortisationSchedule.first?.remaining == 0
        )
        #expect(viewModel.amortisationSchedule.count == 1)
    }
}
