//
//  Decimal+currencyFormatted.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 23/5/2025.
//

import Foundation

extension Decimal {
    func currencyFormatted(
        maximumFractionDigits: Int = 2
    ) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = maximumFractionDigits

        return currencyFormatter.string(from: self as NSNumber) ?? ""
    }
}
