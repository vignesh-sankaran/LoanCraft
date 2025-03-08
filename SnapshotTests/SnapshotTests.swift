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
        
        let ciPath: StaticString = "/Volumes/workspace/repository/ci_scripts/resources/SnapshotTests/SnapshotTests.swift"
        let localPath: StaticString = #file

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)), file: ciPath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhoneSe)), file: ciPath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13ProMax)), file: ciPath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8), traits: .init(userInterfaceStyle: .dark)), file: ciPath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2)), file: ciPath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2(.landscape))), file: ciPath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2), traits: .init(userInterfaceStyle: .dark)), file: ciPath)
    }
}
