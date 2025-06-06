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
}
