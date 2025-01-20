//
//  AppDelegate.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 20/1/2025.
//

import Firebase

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    @MainActor
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
