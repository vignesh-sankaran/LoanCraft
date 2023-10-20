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

class ViewModel: ObservableObject {
    @Published var mortgage = 500000.0 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    @Published var interest = 0.05 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    @Published var yearsRemaining = 30 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    @Published var repaymentFrequency = 12 {
        didSet {
            calculateMortgageRepayment()
        }
    }
    @Published var mortgageRepayment = 0.0

    func calculateMortgageRepayment() {
        let interestForPeriod = interest / Double(repaymentFrequency)
        let numberOfPeriods = repaymentFrequency * yearsRemaining

        let firstBracket = 1 + interestForPeriod
        let firstPower = pow(firstBracket, Double(numberOfPeriods))
        let topLine = mortgage * interestForPeriod * firstPower

        let bottomLine = firstPower - 1

        mortgageRepayment = topLine / bottomLine
    }

    //    var repayments: [Repayment] {
    //
    //    }

    init() {
        calculateMortgageRepayment()
    }
}
