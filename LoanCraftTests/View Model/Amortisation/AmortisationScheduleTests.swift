//
//  AmortisationScheduleTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 27/4/2025.
//

import Testing

@testable import LoanCraft

struct AmortisationScheduleTests {
    @Test func `init`() {
        let amortisationSchedule = AmortisationSchedule(
            principal: 500000,
            interest: 5.0,
            yearsRemaining: 30
        )

        #expect(amortisationSchedule.schedule.count == 30 * 12)
    }
}
