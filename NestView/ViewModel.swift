//
//  ViewModel.swift
//  NestView
//
//  Created by Vignesh Sankaran on 16/4/2023.
//

import Foundation
import SwiftUI

struct Repayment: Identifiable {
    var id = UUID()
    var amount: Double
}

struct ChartData: Identifiable {
    var id = UUID()
    var principal: Double
    var interest: Double
    var total: Double {
        principal + interest
    }
    var formattedTotal: String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(from: total as NSNumber)
    }
}

@Observable class ViewModel {
    var chartData: ChartData
    var mortgage = 500000.0 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    var interest = 0.05 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    var yearsRemaining = 30 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    var repaymentFrequency = 26 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    var mortgageRepayment = 0.0

    func calculateMortgageRepayment() {
        let interestForPeriod = interest / Double(repaymentFrequency)
        let numberOfPeriods = repaymentFrequency * yearsRemaining

        let firstBracket = 1 + interestForPeriod
        let firstPower = pow(firstBracket, Double(numberOfPeriods))
        let topLine = mortgage * interestForPeriod * firstPower

        let bottomLine = firstPower - 1

        mortgageRepayment = topLine / bottomLine
        
        let totalMortgage = mortgageRepayment * Double(repaymentFrequency) * Double(yearsRemaining)
        let interest = totalMortgage - mortgage
        chartData = ChartData(principal: mortgage, interest: interest)
    }

    init() {
        chartData = ChartData(principal: 0, interest: 0)
        calculateMortgageRepayment()
    }
}
