//
//  SelectedTextField.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 28/1/2025.
//

enum SelectedTextField: Hashable, CaseIterable {
    case mortgageAmount
    case interest
    case yearsRemaining
    
    var next: Self {
        switch self {
        case .mortgageAmount:
            return .interest
        case .interest:
            return .yearsRemaining
        case .yearsRemaining:
            return .mortgageAmount
        }
    }
    
    var previous: Self {
        switch self {
        case .mortgageAmount:
            return .yearsRemaining
        case .interest:
            return .mortgageAmount
        case .yearsRemaining:
            return .interest
        }
    }
}
