//
//  AnalyticsService.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 2/2/2025.
//

import AmplitudeSwift
import AmplitudeSwiftSessionReplayPlugin
import Foundation

@Observable final class AnalyticsService {
    private let amplitudeService: Amplitude

    static let instance = AnalyticsService()

    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "AMPLITUDE_API_KEY") as? String
        else {
            fatalError("Amplitude API key not found!")
        }
        amplitudeService = Amplitude(
            configuration: Configuration(
                apiKey: apiKey
            ))
        amplitudeService.add(
            plugin: AmplitudeSwiftSessionReplayPlugin(
                sampleRate: 1.0,
                maskLevel: .conservative
            )
        )

        #if DEBUG
            amplitudeService.configuration.offline = true
        #endif
    }

    func track(
        _ event: Event,
        properties: [String: Any]? = nil
    ) {
        amplitudeService.track(
            eventType: event.rawValue,
            eventProperties: properties
        )
    }
}
