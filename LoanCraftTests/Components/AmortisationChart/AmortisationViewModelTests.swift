//
//  LoanCraftViewModel+calculateAmortisationScheduleTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 30/4/2025.
//

import Testing
import Foundation

@testable import LoanCraft

struct AmortisationViewModelTests {
    @Test("selectedYear > schedule.count")
    func test_schedule_didSet_selectedYear_greater_than() {
        let viewModel = LoanCraftViewModel()
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)
        amortisationViewModel.calculateSchedule()
        amortisationViewModel.selectedYear = 20
        viewModel.yearsRemaining = 10

        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.selectedYear == 10)
    }

    @Test("selectedYear = schedule.count")
    func test_schedule_didSet_selectedYear_equal() {
        let viewModel = LoanCraftViewModel()
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)
        amortisationViewModel.calculateSchedule()
        amortisationViewModel.selectedYear = 31
        viewModel.yearsRemaining = 10

        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.selectedYear == 10)
    }

    @Test("Schedule didSet: selectedYear < schedule.count")
    func test_schedule_didSet_selectedYear_less_than() {
        let viewModel = LoanCraftViewModel()
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)
        amortisationViewModel.calculateSchedule()
        amortisationViewModel.selectedYear = 15
        viewModel.yearsRemaining = 20

        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.selectedYear == 15)
    }

    @Test("calculateSchedule: 500k")
    func test() {
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: LoanCraftViewModel())

        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.schedule.first?.remaining == 500_000)
        #expect(amortisationViewModel.schedule.last?.remaining == 0)
        #expect(amortisationViewModel.schedule.count == 31)
    }

    @Test("calculateSchedule: 0k")
    func test_0() {
        let viewModel = LoanCraftViewModel()
        viewModel.mortgage = 0
        viewModel.yearsRemaining = 1
        let amortisationViewModel = AmortisationViewModel(
            loanCraftViewModel: viewModel
        )

        amortisationViewModel.calculateSchedule()

        #expect(
            amortisationViewModel.schedule.first?.year == 0
        )
        #expect(
            amortisationViewModel.schedule.first?.remaining == 0
        )
        #expect(amortisationViewModel.schedule.count == 2)
    }

    @Test("calculateSchedule: years remaining = 0")
    func test_nil_viewModel() {
        let viewModel = LoanCraftViewModel()
        viewModel.yearsRemaining = 0
        let amortisationViewModel = AmortisationViewModel(
            loanCraftViewModel: viewModel
        )
        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.schedule.count == 1)
        #expect(
            amortisationViewModel.schedule.first?.year == 0
        )
        #expect(
            amortisationViewModel.schedule.first?.remaining == 500_000
        )
    }

    @Test("View model updates")
    func test_viewModel_updates() {
        let viewModel = LoanCraftViewModel()
        viewModel.mortgage = 300_000
        viewModel.yearsRemaining = 25
        viewModel.interest = 0.04
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)

        amortisationViewModel.calculateSchedule()
        let initialScheduleCount = amortisationViewModel.schedule.count

        viewModel.yearsRemaining = 15
        amortisationViewModel.calculateSchedule()
        #expect(amortisationViewModel.schedule.count != initialScheduleCount)
        #expect(amortisationViewModel.schedule.count == 16)
        #expect(amortisationViewModel.schedule.first?.remaining == 300_000)
        #expect(amortisationViewModel.schedule.last?.remaining == 0)
    }

    @Test("Years remaining calculation")
    func test_yearsRemaining_calculation() {
        let viewModel = LoanCraftViewModel()
        viewModel.yearsRemaining = 30
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)

        amortisationViewModel.calculateSchedule()
        amortisationViewModel.selectedYear = 10

        #expect(amortisationViewModel.yearsRemaining == "20")
    }

    @Test("Principal remaining calculation - valid index")
    func test_principalRemaining_valid_index() {
        let viewModel = LoanCraftViewModel()
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)

        amortisationViewModel.calculateSchedule()
        amortisationViewModel.selectedYear = 0

        let principalRemaining = amortisationViewModel.principalRemaining
        #expect(principalRemaining == Decimal(500_000).currencyFormatted())
    }

    @Test("Principal remaining calculation - invalid index")
    func test_principalRemaining_invalid_index() {
        let viewModel = LoanCraftViewModel()
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)

        amortisationViewModel.calculateSchedule()
        amortisationViewModel.selectedYear = 999

        let principalRemaining = amortisationViewModel.principalRemaining
        #expect(principalRemaining == Decimal(0).currencyFormatted())
    }

    @Test("Principal remaining calculation - empty schedule")
    func test_principalRemaining_empty_schedule() {
        let viewModel = LoanCraftViewModel()
        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)

        let principalRemaining = amortisationViewModel.principalRemaining
        #expect(principalRemaining == Decimal(0).currencyFormatted())
    }

    @Test("Different repayment frequencies")
    func test_different_repayment_frequencies() {
        let viewModel = LoanCraftViewModel()
        viewModel.mortgage = 100_000
        viewModel.yearsRemaining = 10
        viewModel.repaymentFrequency = .month

        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)
        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.schedule.count == 11)
        #expect(amortisationViewModel.schedule.first?.remaining == 100_000)
        #expect(amortisationViewModel.schedule.last?.remaining == 0)
    }

    @Test("High interest rate calculation")
    func test_high_interest_rate() {
        let viewModel = LoanCraftViewModel()
        viewModel.mortgage = 200_000
        viewModel.yearsRemaining = 5
        viewModel.interest = 0.15

        let amortisationViewModel = AmortisationViewModel(loanCraftViewModel: viewModel)
        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.schedule.count == 6)
        #expect(amortisationViewModel.schedule.first?.remaining == 200_000)
        #expect(amortisationViewModel.schedule.last?.remaining == 0)

        let yearOneRemaining = amortisationViewModel.schedule[1].remaining
        #expect(yearOneRemaining > 150_000)
    }
}
