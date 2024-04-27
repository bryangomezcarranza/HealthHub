//
//  HealthDataListView.swift
//  health hub
//
//  Created by Bryan Gomez on 4/27/24.
//

import SwiftUI

struct HealthDataListView: View {
    
    var metric: HealthMetricContext
    
    @State private var isShowingAddData = false
    @State private var addDate: Date = .now
    @State private var valueToAdd: String = ""
    
    var body: some View {
        List(0..<28) { i in
//            HStack {
//                Text(Date(), format: .dateTime.month().day().year())
//                Spacer()
//               // Text(10000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
//                
//            }
            LabeledContent {
                               Text(1000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
                                   .foregroundStyle(.primary)
                           } label: {
                               Text(Date(), format: .dateTime.month().day().year())
                           }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDate, displayedComponents: .date)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
    }
}
