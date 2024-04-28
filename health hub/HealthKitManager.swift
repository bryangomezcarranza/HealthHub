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
    
    func addSimulatorData() async  {
        var mocSamples: [HKQuantitySample] = []
        
        for i in 0..<28 {
            guard
                let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now),
                let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate)
            else { return }
            
            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
            
            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
            
            mocSamples.append(stepSample)
            mocSamples.append(weightSample)
        }
        
        try! await store.save(mocSamples)
        debugPrint("Dummy Data sent up")
    }
}
