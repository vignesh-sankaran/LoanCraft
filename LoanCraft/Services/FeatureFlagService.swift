//
//  FeatureFlagService.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 21/4/2025.
//

import Foundation
import Experiment

@Observable final class FeatureFlagService {
    static let instance = FeatureFlagService()

    var amortisationGraphEnabled = false

    init() {
        guard
            let apiKey = Bundle.main.object(
                forInfoDictionaryKey: "AMPLITUDE_API_KEY"
            ) as? String
        else {
            fatalError("Amplitude API key not found!")
        }

        let experiment = Experiment.initializeWithAmplitudeAnalytics(
            apiKey: apiKey,
            config: ExperimentConfigBuilder().build()
        )

        experiment.fetch(user: nil) { error, argument in
            let variant = experiment.variant("amortisation-graph")
            if variant.value == "on" {
                self.amortisationGraphEnabled = true
            } else {
                self.amortisationGraphEnabled = false
            }
        }
    }
}
