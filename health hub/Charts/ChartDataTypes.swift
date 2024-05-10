//
//  ChartDataTypes.swift
//  health hub
//
//  Created by Bryan Gomez on 5/7/24.
//

import Foundation

struct WeekdayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
