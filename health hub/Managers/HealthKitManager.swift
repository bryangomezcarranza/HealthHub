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
    
    var stepData: [HealthMetric] = []
    var weightData: [HealthMetric] = []
    var weightDiffData: [HealthMetric] = []
    
    func fetchWeight() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        guard
            let endDate = calendar.date(byAdding: .day, value: 1, to: today),
            let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        else { return }
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let weightType = HKQuantityType(.bodyMass)
        let samplePredicate = HKSamplePredicate.quantitySample(type: weightType, predicate: queryPredicate)
        
        let weightQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .mostRecent, anchorDate: endDate, intervalComponents: .init(day: 1))
        
        do {
            let weights = try await weightQuery.result(for: store)
            
            weightData = weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch {
            
        }
    }
    
    func fetchWeightDifferentials() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        guard
            let endDate = calendar.date(byAdding: .day, value: 1, to: today),
            let startDate = calendar.date(byAdding: .day, value: -29, to: endDate)
        else { return }
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let weightType = HKQuantityType(.bodyMass)
        let samplePredicate = HKSamplePredicate.quantitySample(type: weightType, predicate: queryPredicate)
        
        let weightQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .mostRecent, anchorDate: endDate, intervalComponents: .init(day: 1))
        
        do {
            let weights = try await weightQuery.result(for: store)
            
            weightDiffData = weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch {
            
        }
    }
    
    func fetchStepCount() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        guard
            let endDate = calendar.date(byAdding: .day, value: 1, to: today),
            let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        else { return }
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepType = HKQuantityType(.stepCount)
        let samplePredicate = HKSamplePredicate.quantitySample(type: stepType, predicate: queryPredicate)
        
        let stepQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .cumulativeSum, anchorDate: endDate, intervalComponents: .init(day: 1))
        
        do {
            let stepCounts = try await stepQuery.result(for: store)
            
            stepData = stepCounts.statistics().map {
                .init(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        } catch {
            
        }
    }
    
    func addSimulatorData() async  {
        var mocSamples: [HKQuantitySample] = []
        
        for i in 0..<27 {
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
