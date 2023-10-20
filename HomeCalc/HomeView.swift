//
//  ContentView.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import Charts
import Foundation
import SwiftUI

struct SampleRepaymentData {
    let amount: Int
    let year: Int
}

let data = [
    SampleRepaymentData(amount: 100, year: 0),
    SampleRepaymentData(amount: 90, year: 1),
    SampleRepaymentData(amount: 60, year: 2),
    SampleRepaymentData(amount: 40, year: 3),
    SampleRepaymentData(amount: 10, year: 4),
]

struct HomeView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Mortgage amount")
                    TextField(
                        "Mortgage amount", value: $viewModel.mortgage,
                        format: .currency(code: "USD")
                    )
                    .keyboardType(.numberPad)
                }
                HStack {
                    Text("Interest")
                    TextField("Interest", value: $viewModel.interest, format: .percent)
                        .keyboardType(
                            .decimalPad)
                }
                HStack {
                    Text("Years remaining")
                    TextField("Years remaining", value: $viewModel.yearsRemaining, format: .number)
                        .keyboardType(.numberPad)
                }
                // Set up saving of value if on focus, then off focus has a 0, empty, or invalid value
                HStack {
                    Text("Repayment frequency")
                    Picker("Repayment frequency", selection: $viewModel.repaymentFrequency) {
                        Text("Monthly").tag(12)
                        Text("Fortnightly").tag(26)
                    }.pickerStyle(.segmented)
                }
                HStack {
                    Text("Repayment amount")
                    Text(viewModel.mortgageRepayment, format: .currency(code: "USD"))
                }
                // Set up fancy swift chart in here
                // Need to set up an amortisation schedule array type
                //
                Chart(data, id: \.year) { principalRemaining in
                    LineMark(
                        x: .value("Year", principalRemaining.year),
                        y: .value("Amount", principalRemaining.amount)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    .interpolationMethod(.catmullRom)

                }

            }
            .padding()
            .navigationTitle("HomeCalc")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
