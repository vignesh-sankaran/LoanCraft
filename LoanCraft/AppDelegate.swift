//
//  AppDelegate.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 20/1/2025.
//

import NewRelic
import PostHog
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    @MainActor
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let POSTHOG_API_KEY = "phc_H3MgZaVIGWMjw7gus9csjp6ajvC20V3GOPkIvoTk9Rn"
        let POSTHOG_HOST = "https://eu.i.posthog.com"
        let config = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)

        config.sessionReplay = true
        config.sessionReplayConfig.maskAllImages = false
        config.sessionReplayConfig.maskAllTextInputs = true
        config.sessionReplayConfig.screenshotMode = true

        PostHogSDK.shared.setup(config)

        NewRelic.start(withApplicationToken: "AA404fc53169dd101da646745ece4312c54ba48d1b-NRMA")

        return true
    }
}
