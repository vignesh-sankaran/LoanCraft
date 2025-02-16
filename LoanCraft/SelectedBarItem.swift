//
//  SelectedBarItem.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 28/1/2025.
//

enum SelectedBarItem {
    case interest, principal

    var trackingValue: Event {
        switch self {
        case .principal:
            return .principalBarMark
        case .interest:
            return .interestBarMark
        }
    }
}
