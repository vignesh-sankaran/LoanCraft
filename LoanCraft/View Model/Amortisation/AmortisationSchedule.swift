//
//  AmortisationSchedule.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 27/4/2025.
//

import Foundation

struct AmortisationSchedule {
    var schedule: [AmortisationData] = []

    init(
        principal: Decimal,
        interest: Decimal,
        yearsRemaining: Int
    ) {
        let monthlyInterestRate = interest / 12
        let totalPayments = yearsRemaining * 12

        let topRow =
            principal * (monthlyInterestRate * pow(1 + monthlyInterestRate, totalPayments))
        let monthlyPayment = topRow / (pow(1 + monthlyInterestRate, totalPayments) - 1)

        var remainingBalance = principal

        for month in 1...totalPayments {
            let interestPayment = remainingBalance * monthlyInterestRate
            let principalPayment = monthlyPayment - interestPayment
            remainingBalance -= principalPayment

            if remainingBalance < 0 {
                remainingBalance = 0
            }

            schedule.append(
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
