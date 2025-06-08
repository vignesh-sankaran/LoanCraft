//
//  LoanCraftViewModel.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 16/4/2023.
//

import SwiftUI

@Observable class LoanCraftViewModel {
    var chartData: ChartData
    var mortgage: Decimal = 500000.0 {
        didSet {
            calculateMortgageRepayment()
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
        }
    }
    var repaymentFrequency: RepaymentFrequency = .fortnight {
        didSet {
            calculateMortgageRepayment()
        }
    }
    private(set) var totalInterest: Decimal = 0.0
    private(set) var totalMortgage: Decimal = 0.0
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

        totalMortgage = mortgageRepayment * Decimal(repaymentsPerYear) * Decimal(yearsRemaining)
        totalInterest = totalMortgage - mortgage
        chartData = ChartData(principal: mortgage, interest: totalInterest)
    }

    init() {
        chartData = ChartData(principal: 0, interest: 0)
        calculateMortgageRepayment()
    }
}
