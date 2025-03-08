//
//  ChartDataTests.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 8/3/2025.
//

import Testing

@testable import LoanCraft

struct ChartDataTests {
    @Test func total() {
        let data = ChartData(
            principal: 100_000,
            interest: 10_000
        )
        
        #expect(data.total == 110_000)
    }
    
    @Test func formattedPrincipal() async throws {
        let data = ChartData(
            principal: 100_000,
            interest: 10_000
        )
        
        #expect(data.formattedPrincipal == "$100,000.00")
    }
    
    @Test func formattedInterest() async throws {
        let data = ChartData(
            principal: 100_000,
            interest: 10_000
        )
        
        #expect(data.formattedInterest == "$10,000.00")
    }
    
    @Test func formattedTotal() async throws {
        let data = ChartData(
            principal: 100_000,
            interest: 10_000
        )
        
        #expect(data.formattedTotal == "$110,000.00")
    }
}
