//
//  LoanCraftApp.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import SwiftUI

@main
struct LoanCraftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            LoanCraftView()
        }
    }
}
