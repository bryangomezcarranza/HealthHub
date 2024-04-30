//
//  health_hubApp.swift
//  health hub
//
//  Created by Bryan Gomez on 4/26/24.
//

import SwiftUI

@main
struct health_hubApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
