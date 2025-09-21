//
//  ChartData.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Foundation

final class ChartData: Identifiable {
    var id = UUID()
    var principal: Decimal
    var interest: Decimal
    var total: Decimal {
        principal + interest
    }
    let token = UUID().uuidString
    private var loanCraftViewModel: LoanCraftViewModel

    init(
        from viewModel: LoanCraftViewModel
    ) {
        loanCraftViewModel = viewModel
        principal = viewModel.mortgage
        interest = viewModel.totalInterest

        observeChanges()
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
                self.principal = self.loanCraftViewModel.mortgage
                self.interest = self.loanCraftViewModel.totalInterest
            })
    }
}
