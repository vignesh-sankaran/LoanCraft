//
//  ViewModel.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 16/4/2023.
//

import Foundation
import SwiftUI

struct Repayment {
    let amount: Double
    let year: Int
}

struct SampleRepaymentData {
    let amount: Int
    let year: Int
}

struct TotalRepayment: Identifiable {
    var id = UUID()
    var total: Double
    var principal: Double
    var interest: Double
}

@Observable class ViewModel {
    var chartData = TotalRepayment(total: 500000, principal: 0, interest: 0)
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
    var repaymentFrequency = 12 {
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
        chartData = .init(total: mortgage, principal: 0, interest: 0)
    }

    init() {
        calculateMortgageRepayment()
        chartData = .init(total: mortgage, principal: 0, interest: 0)
    }
}
