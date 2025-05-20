//
//  Amortisation.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 27/4/2025.
//

import Foundation

struct AmortisationData: Identifiable, Equatable {
    let id = UUID()
    let month: Int
    let totalPayment: Decimal
    let principal: Decimal
    let interest: Decimal
    let remainingPrincipal: Decimal
    let remainingInterest: Decimal
    let remainingTotal: Decimal
}
