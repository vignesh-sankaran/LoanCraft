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
    @Published var mortgage = 0
    @Published var interest = 0.0
    @Published var yearsRemaining = 30
    @Published var repaymentFrequency = 26
    @Published var mortgageRepayment = 0.0
    
    func calculateMortgageRepayment() {
        mortgageRepayment = Double(mortgage + 100)
//        let interestRate = interest / Double(100) / Double(repaymentFrequency)
//
//        let topLine = Double(mortgage) * interestRate * pow((1 + interestRate), Double(repaymentFrequency * yearsRemaining))
//        let bottomLine = pow((1 + interestRate), Double(repaymentFrequency * yearsRemaining)) - 1
//        mortgageRepayment = topLine / bottomLine
    }

    init() {
        cancellable.append($mortgage.sink { _ in self.calculateMortgageRepayment() })
        cancellable.append($interest.sink { _ in self.calculateMortgageRepayment() })
        cancellable.append($yearsRemaining.sink { _ in self.calculateMortgageRepayment() })
        cancellable.append($repaymentFrequency.sink { _ in self.calculateMortgageRepayment() })
    }
}
