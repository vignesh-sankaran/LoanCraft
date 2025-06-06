//
//  LoanCraftViewModel.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 16/4/2023.
//

import SwiftUI

@Observable class LoanCraftViewModel {
    var amortisationViewModel = AmortisationViewModel()
    var chartData: ChartData
    var mortgage: Decimal = 500000.0 {
        didSet {
            calculateMortgageRepayment()
            amortisationViewModel.calculateSchedule()
        }
    }
    var interest: Decimal = 0.05 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    var yearsRemaining = 30 {
        didSet {
            calculateMortgageRepayment()
            amortisationViewModel.calculateSchedule()
        }
    }
    var repaymentFrequency: RepaymentFrequency = .fortnight {
        didSet {
            calculateMortgageRepayment()
        }
    }
    private(set) var mortgageRepayment: Decimal = 0.0

    func calculateMortgageRepayment() {
        let repaymentsPerYear = repaymentFrequency.repaymentsPerYear
        let interestForPeriod = interest / Decimal(repaymentsPerYear)
        let numberOfPeriods = repaymentsPerYear * yearsRemaining

        let firstBracket = 1 + interestForPeriod
        let firstPower = pow(firstBracket, numberOfPeriods)
        let topLine = mortgage * interestForPeriod * firstPower

        let bottomLine = firstPower - 1

        mortgageRepayment = topLine / bottomLine

        let totalMortgage = mortgageRepayment * Decimal(repaymentsPerYear) * Decimal(yearsRemaining)
        let interest = totalMortgage - mortgage
        chartData = ChartData(principal: mortgage, interest: interest)
    }

    init() {
        chartData = ChartData(principal: 0, interest: 0)
        amortisationViewModel.setViewModel(self)
        amortisationViewModel.calculateSchedule()
        calculateMortgageRepayment()
    }
}
