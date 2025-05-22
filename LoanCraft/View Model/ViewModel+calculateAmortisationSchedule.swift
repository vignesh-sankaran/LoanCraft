//
//  ViewModel+calculateAmortisationSchedule.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 30/4/2025.
//

import Foundation

extension ViewModel {
    func calculateAmortisationSchedule() {
        amortisationSchedule = []
        let monthlyInterestRate = interest / Decimal(yearsRemaining)
        let totalPayments = yearsRemaining * 12

        let topRow = mortgage * (monthlyInterestRate * pow(1 + monthlyInterestRate, totalPayments))
        let monthlyPayment = topRow / (pow(1 + monthlyInterestRate, totalPayments) - 1)

        var remainingPrincipal = mortgage
        var remainingInterest = chartData.interest
        var remainingTotal = chartData.total

        for month in 1...totalPayments {
            let interestPayment = remainingPrincipal * monthlyInterestRate
            let principalPayment = monthlyPayment - interestPayment
            remainingPrincipal -= principalPayment
            remainingInterest -= interestPayment
            remainingTotal -= monthlyPayment

            if remainingPrincipal < 0 {
                remainingPrincipal = 0
            }

            amortisationSchedule.append(
                .init(month: month, remaining: remainingPrincipal)
            )
        }
    }
}
