//
//  SnapshotTests.swift
//  SnapshotTests
//
//  Created by Vignesh Sankaran on 6/3/2025.
//

import SnapshotTesting
import XCTest

@testable import LoanCraft

final class SnapshotTests: XCTestCase {
    func test_default() {
        let view = LoanCraftView()
        
        assertSnapshot(of: view, as: .image)
    }
}
