//
//  ChartData.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Foundation

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
