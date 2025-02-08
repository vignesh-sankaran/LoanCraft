//
//  ViewModel.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 16/4/2023.
//

import Foundation
import SwiftUI

struct Repayment: Identifiable {
    var id = UUID()
    var amount: Decimal
}

struct ChartData: Identifiable {
    var id = UUID()
    var principal: Decimal
    var interest: Decimal
    var total: Decimal {
        principal + interest
    }
    var formattedPrincipal: String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(from: principal as NSNumber)
    }
    var formattedInterest: String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(from: interest as NSNumber)
    }
    var formattedTotal: String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(from: total as NSNumber)
    }
    let iterator = SelectedTextField.allCases.makeIterator()

}

@Observable class ViewModel {
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
    var mortgageRepayment: Decimal = 0.0

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
        calculateMortgageRepayment()
    }
}
