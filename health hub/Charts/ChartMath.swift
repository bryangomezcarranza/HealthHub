//
//  ChartMath.swift
//  health hub
//
//  Created by Bryan Gomez on 5/7/24.
//

import Foundation
import Algorithms

struct ChartMath {
    static func averageWeekdayCount( for metric: [HealthMetric]) -> [WeekdayChartData] {
        
        let sortedByWeekDay = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt } // All our 1,2,3,4,5 etc 
        let weekdayArray = sortedByWeekDay.chunked { $0.date.weekdayInt == $1.date.weekdayInt } // creates new arrays based on the day of the week. Example 11112222 = [1,1,1,1], [2,2,2,2]
        
        var weekdayChartData: [WeekdayChartData] = []
        
        // Goes through every day of the week.
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value } // sum of an array of step values
            let avgSteps = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgSteps))
        }
        
        return weekdayChartData
    }
}
