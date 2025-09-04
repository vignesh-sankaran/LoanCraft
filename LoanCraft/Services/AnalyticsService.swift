//
//  AnalyticsService.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 2/2/2025.
//

import Foundation
import PostHog

@Observable final class AnalyticsService {
    static let instance = AnalyticsService()

    func track(
        _ event: Event,
        properties: [String: Any]? = nil
    ) {
        PostHogSDK.shared.capture(
            event.rawValue,
            properties: properties
        )
    }
}
