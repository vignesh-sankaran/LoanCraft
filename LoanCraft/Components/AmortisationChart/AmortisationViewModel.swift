//
//  AmortisationViewModel.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 26/5/2025.
//

import Foundation
import SwiftUI

@Observable final class AmortisationViewModel {
    var selectedYear = 0
    private(set) var schedule: [AmortisationData] = []
    private let loanCraftViewModel: LoanCraftViewModel
    let token = UUID().uuidString

    init(loanCraftViewModel: LoanCraftViewModel) {
        self.loanCraftViewModel = loanCraftViewModel
        observeChanges()
    }

    var yearsRemaining: String {
        String(schedule.count - 1 - selectedYear)
    }

    var principalRemaining: String {
        if schedule.count == 0 {
            Decimal(0).currencyFormatted()
        } else {
            schedule[selectedYear].remaining.currencyFormatted()
        }
    }

    func observeChanges() {
        withObservationTracking(
            {
                _ = self.loanCraftViewModel.mortgage
                _ = self.loanCraftViewModel.yearsRemaining
                _ = self.loanCraftViewModel.interest
                _ = self.loanCraftViewModel.repaymentFrequency
            },
            token: {
                self.token
            },
            didChange: {
                self.calculateSchedule()
            })
    }

    func calculateSchedule() {
        schedule = [
            .init(year: 0, remaining: loanCraftViewModel.mortgage)
        ]

        let monthlyInterestRate =
            loanCraftViewModel.interest / Decimal(loanCraftViewModel.yearsRemaining)
        let totalPayments = loanCraftViewModel.yearsRemaining * 12

        let topRow =
            loanCraftViewModel.mortgage
            * (monthlyInterestRate * pow(1 + monthlyInterestRate, totalPayments))
        let monthlyPayment = topRow / (pow(1 + monthlyInterestRate, totalPayments) - 1)

        var remainingPrincipal = loanCraftViewModel.mortgage
        var remainingInterest = loanCraftViewModel.totalInterest
        var remainingTotal = loanCraftViewModel.totalMortgage

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

func withObservationTracking(
    _ apply: @escaping () -> Void,
    token: @escaping () -> String?,
    willChange: (@Sendable () -> Void)? = nil,
    didChange: @escaping @Sendable () -> Void
) {
    withObservationTracking(apply) {
        guard token() != nil else { return }
        willChange?()
        RunLoop.current.perform {
            didChange()
            withObservationTracking(
                apply,
                token: token,
                willChange: willChange,
                didChange: didChange
            )
        }
    }
}
