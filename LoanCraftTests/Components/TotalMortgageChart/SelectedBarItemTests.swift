//
//  SelectedBarItem.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Testing

@testable import LoanCraft

struct SelectedBarItemTests {
    @Test("Tracking value")
    func trackingValue() {
        #expect(SelectedBarItem.interest.trackingValue == .interestBarMark)
        #expect(SelectedBarItem.principal.trackingValue == .principalBarMark)
    }
}
