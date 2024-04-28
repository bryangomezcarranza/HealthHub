//
//  HealthKitManager.swift
//  health hub
//
//  Created by Bryan Gomez on 4/28/24.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    
    let type: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
