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

        viewModel.mortgage = 250.000
        viewModel.interest = 0.05
        viewModel.yearsRemaining = 30

        #expect(viewModel.amortisationSchedule.count == 30)
    }
}
