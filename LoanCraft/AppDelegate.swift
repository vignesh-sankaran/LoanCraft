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
        guard
            let postHogAPIKey = Bundle.main.object(forInfoDictionaryKey: "POSTHOG_API_KEY")
                as? String
        else {
            fatalError("PostHog API Key not found!")
        }

        let POSTHOG_HOST = "https://eu.i.posthog.com"
        let config = PostHogConfig(apiKey: postHogAPIKey, host: POSTHOG_HOST)

        config.sessionReplay = true
        config.sessionReplayConfig.maskAllImages = false
        config.sessionReplayConfig.maskAllTextInputs = true
        config.sessionReplayConfig.screenshotMode = true

        PostHogSDK.shared.setup(config)

        guard
            let newRelicToken = Bundle.main.object(forInfoDictionaryKey: "NEWRELIC_TOKEN")
                as? String
        else {
            fatalError("NewRelic token not found!")
        }

        NewRelic.start(withApplicationToken: newRelicToken)

        return true
    }
}
