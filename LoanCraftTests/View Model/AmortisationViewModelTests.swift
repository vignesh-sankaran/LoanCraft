//
//  ViewModel+calculateAmortisationScheduleTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 30/4/2025.
//

import Testing

@testable import LoanCraft

struct AmortisationViewModelTests {
    @Test("selectedYear > schedule.count")
    func test_schedule_didSet_selectedYear_greater_than() {
        let viewModel = ViewModel()
        let amortisationViewModel = AmortisationViewModel()
        amortisationViewModel.setViewModel(
            viewModel
        )
        amortisationViewModel.calculateSchedule()
        amortisationViewModel.selectedYear = 20
        viewModel.yearsRemaining = 10

        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.selectedYear == 10)
    }

    @Test("selectedYear = schedule.count")
    func test_schedule_didSet_selectedYear_equal() {

    }

    @Test("Schedule didSet: selectedYear < schedule.count")
    func test_schedule_didSet_selectedYear_less_than() {

    }

    @Test("calculateSchedule: 500k")
    func test() {
        let amortisationViewModel = AmortisationViewModel()
        amortisationViewModel.setViewModel(
            .init()
        )

        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.schedule.first?.remaining == 500_000)
        #expect(amortisationViewModel.schedule.last?.remaining == 0)
        #expect(amortisationViewModel.schedule.count == 31)
    }

    @Test("calculateSchedule: 0k")
    func test_0() {
        let viewModel = ViewModel()
        viewModel.mortgage = 0
        viewModel.yearsRemaining = 1
        let amortisationViewModel = AmortisationViewModel()
        amortisationViewModel.setViewModel(
            viewModel
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

    @Test("calculateSchedule: Nil view model")
    func test_nil_viewModel() {
        let amortisationViewModel = AmortisationViewModel()
        amortisationViewModel.calculateSchedule()

        #expect(amortisationViewModel.schedule.isEmpty == true)
    }

    @Test("View model updates")
    func test_viewModel_updates() {

    }
}
