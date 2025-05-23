//
//  Decimal+currencyFormattedTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 23/5/2025.
//

import Foundation
import Testing

@testable import LoanCraft

struct Decimal_currencyFormattedTests {
    @Test("Decimal currencyFormatted")
    func decimalToCurrency() {
        let decimal: Decimal = 123_456.7891

        #expect(decimal.currencyFormatted() == "$123,456.79")
    }
}
