//
//  AmortisationViewModel.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 26/5/2025.
//

import Foundation
import SwiftUI

@Observable final class AmortisationViewModel {
    var selectedYear: Int = 0
    private(set) var schedule: [AmortisationData] = []

    private(set) var viewModel: LoanCraftViewModel?
    var yearsRemaining: String {
        String(schedule.count - 1 - selectedYear)
    }

    var principalRemaining: String {
        schedule[selectedYear].remaining.currencyFormatted()
    }

    func setViewModel(_ viewModel: LoanCraftViewModel) {
        self.viewModel = viewModel
    }

    func calculateSchedule() {
        guard let viewModel else { return }
        schedule = [
            .init(year: 0, remaining: viewModel.mortgage)
        ]

        let monthlyInterestRate = viewModel.interest / Decimal(viewModel.yearsRemaining)
        let totalPayments = viewModel.yearsRemaining * 12

        let topRow =
            viewModel.mortgage * (monthlyInterestRate * pow(1 + monthlyInterestRate, totalPayments))
        let monthlyPayment = topRow / (pow(1 + monthlyInterestRate, totalPayments) - 1)

        var remainingPrincipal = viewModel.mortgage
        var remainingInterest = viewModel.chartData.interest
        var remainingTotal = viewModel.chartData.total

        guard totalPayments > 0 else { return }

        for month in 1...totalPayments {
            let interestPayment = remainingPrincipal * monthlyInterestRate
            let principalPayment = monthlyPayment - interestPayment
            remainingPrincipal -= principalPayment
            remainingInterest -= interestPayment
            remainingTotal -= monthlyPayment

            if remainingPrincipal < 0 {
                remainingPrincipal = 0
            }

            guard month % 12 == 0 else { continue }
            schedule.append(
                .init(year: month / 12, remaining: remainingPrincipal)
            )
        }

        if selectedYear > schedule.count {
            selectedYear = schedule.count - 1
        }
    }
}
