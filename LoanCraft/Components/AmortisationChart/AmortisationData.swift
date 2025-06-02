//
//  Amortisation.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 27/4/2025.
//

import Foundation

struct AmortisationData: Identifiable, Equatable {
    let id = UUID()
    let year: Int
    let remaining: Decimal
}
