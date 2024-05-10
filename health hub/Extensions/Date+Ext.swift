//
//  Date+Ext.swift
//  health hub
//
//  Created by Bryan Gomez on 5/7/24.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekDayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }
}
