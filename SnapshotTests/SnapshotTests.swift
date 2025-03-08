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
    let xcodeCloudPath: StaticString = "/Volumes/workspace/repository/ci_scripts/SnapshotTests.swift"

    func test_default() {
        let view = LoanCraftView()
        
        let filePath: StaticString
        
        if ProcessInfo.processInfo.environment["CI"] == "TRUE" {
            filePath = xcodeCloudPath
        } else {
            filePath = #file
        }

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8)), file: filePath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhoneSe)), file: filePath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13ProMax)), file: filePath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone8), traits: .init(userInterfaceStyle: .dark)), file: filePath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2)), file: filePath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2(.landscape))), file: filePath)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPad10_2), traits: .init(userInterfaceStyle: .dark)), file: filePath)
    }
}
