//
//  RepaymentFrequency.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/2/2025.
//

enum RepaymentFrequency: String, CaseIterable {
    case week
    case fortnight
    case month
    case year
    
    var repaymentsPerYear: Int {
        switch self {
        case .week:
            return 52
        case .fortnight:
            return 26
        case .month:
            return 12
        case .year:
            return 1
        }
    }
}
