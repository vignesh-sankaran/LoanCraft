//
//  Amortisation.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 27/4/2025.
//

import Foundation

enum AmortisationDataType: String {
    case principal, interest, total
}

struct AmortisationScheduleData: Identifiable, Equatable {
    let id = UUID()
    let type: AmortisationDataType
    let schedule: [AmortisationData]
}

struct AmortisationData: Identifiable, Equatable {
    let id = UUID()
    let year: Int
    let remaining: Decimal
}
