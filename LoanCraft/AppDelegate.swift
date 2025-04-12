//
//  AppDelegate.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 20/1/2025.
//

import NewRelic
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    @MainActor
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        NewRelic.start(withApplicationToken:"AA404fc53169dd101da646745ece4312c54ba48d1b-NRMA")
        return true
    }
}
