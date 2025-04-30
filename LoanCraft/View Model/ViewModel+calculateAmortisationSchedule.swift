//
//  ViewModel+calculateAmortisationSchedule.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 30/4/2025.
//

import Foundation

extension ViewModel {
    func calculateAmortisationSchedule() {
        let monthlyInterestRate = interest / Decimal(yearsRemaining)
        let totalPayments = yearsRemaining * 12

        let topRow = mortgage * (monthlyInterestRate * pow(1 + monthlyInterestRate, totalPayments))
        let monthlyPayment = topRow / (pow(1 + monthlyInterestRate, totalPayments) - 1)

        var remainingBalance = mortgage

        for month in 1...totalPayments {
            let interestPayment = remainingBalance * monthlyInterestRate
            let principalPayment = monthlyPayment - interestPayment
            remainingBalance -= principalPayment

            if remainingBalance < 0 {
                remainingBalance = 0
            }

            amortisationSchedule.append(
                AmortisationData(
                    month: month,
                    totalPayment: monthlyPayment,
                    principal: principalPayment,
                    interest: interestPayment,
                    remainingBalance: remainingBalance
                )
            )
        }
    }
}
