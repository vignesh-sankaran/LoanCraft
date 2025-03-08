//
//  SelectedTextFieldTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Testing

@testable import LoanCraft

struct SelectedTextFieldTests {
    @Test("Next")
    func next() {
        #expect(SelectedTextField.mortgageAmount.next == .interest)
        #expect(SelectedTextField.interest.next == .yearsRemaining)
        #expect(SelectedTextField.yearsRemaining.next == .mortgageAmount)
    }

    @Test("Previous")
    func previous() {
        #expect(SelectedTextField.mortgageAmount.previous == .yearsRemaining)
        #expect(SelectedTextField.interest.previous == .mortgageAmount)
        #expect(SelectedTextField.yearsRemaining.previous == .interest)
    }

    @Test("Tracking")
    func trackingValue() {
        #expect(SelectedTextField.mortgageAmount.trackingValue == .mortgageAmountField)
        #expect(SelectedTextField.interest.trackingValue == .interestField)
        #expect(SelectedTextField.yearsRemaining.trackingValue == .yearsRemainingField)
    }
}
