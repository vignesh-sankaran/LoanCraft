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

struct AmortisationScheduleData: Equatable {
    let type: AmortisationDataType
    let schedule: [AmortisationData]
}

struct AmortisationData: Equatable {
    let month: Int
    let remaining: Decimal
}
