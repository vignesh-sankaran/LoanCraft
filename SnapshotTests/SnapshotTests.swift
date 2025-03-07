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
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)))
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhoneSe)))
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13ProMax)))
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8), traits: .init(userInterfaceStyle: .dark)))
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2)))
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2(.landscape))))
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2), traits: .init(userInterfaceStyle: .dark)))
    }
}
