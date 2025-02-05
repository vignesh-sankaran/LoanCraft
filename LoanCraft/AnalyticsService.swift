//
//  AnalyticsService.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 2/2/2025.
//

import AmplitudeSwift
import Foundation

final class AnalyticsService {
    // Store user id in UserDefaults
    let amplitudeService: Amplitude
    
    init() {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "AMPLITUDE_API_KEY") as! String
        amplitudeService = Amplitude(configuration: Configuration(
            apiKey: apiKey
        ))
    }
    
    func send(event: Event, properties: [String: Any]? = nil) {
        amplitudeService.track(eventType: event.rawValue, eventProperties: properties)
    }
}
