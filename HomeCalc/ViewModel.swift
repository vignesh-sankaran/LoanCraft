//
//  ViewModel.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 16/4/2023.
//

import Combine
import Foundation
import SwiftUI

var cancellable: [AnyCancellable] = []

class ViewModel: ObservableObject {
    @Published var mortgage = 0.0
    @Published var interest = 0.0
    @Published var yearsRemaining = 30
    @Published var repaymentFrequency = 12
    @Published var mortgageRepayment = 0.0
    
    func calculateMortgageRepayment() {
        let interstForPeriod = interest / Double(repaymentFrequency)
        let numberOfPeriods = repaymentFrequency * yearsRemaining

        let firstBracket = 1 + interstForPeriod
        let firstPower = pow(firstBracket, Double(numberOfPeriods))
        let topLine = mortgage * interstForPeriod * firstPower

        let bottomLine = firstPower - 1

        mortgageRepayment = topLine / bottomLine
    }

    init() {
        cancellable.append($mortgage.sink { _ in self.calculateMortgageRepayment() })
        cancellable.append($interest.sink { _ in self.calculateMortgageRepayment() })
        cancellable.append($yearsRemaining.sink { _ in self.calculateMortgageRepayment() })
        cancellable.append($repaymentFrequency.sink { _ in self.calculateMortgageRepayment() })
    }
}
