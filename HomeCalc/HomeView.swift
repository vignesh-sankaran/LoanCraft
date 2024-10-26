//
//  ContentView.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import Charts
import Foundation
import SwiftUI

struct HomeView: View {
    @State var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Mortgage amount")
                TextField(
                    "Mortgage amount", value: $viewModel.mortgage,
                    format: .currency(code: "USD")
                )
                .keyboardType(.numberPad)
                Text("Interest")
                TextField("Interest", value: $viewModel.interest, format: .percent)
                    .keyboardType(
                        .decimalPad)
                Text("Years remaining")
                TextField("Years remaining", value: $viewModel.yearsRemaining, format: .number)
                    .keyboardType(.numberPad)
                // Set up saving of value if on focus, then off focus has a 0, empty, or invalid value
                Text("Repayment frequency")
                Picker("Repayment frequency", selection: $viewModel.repaymentFrequency) {
                    Text("Monthly").tag(12)
                    Text("Fortnightly").tag(26)
                }.pickerStyle(.segmented)
                Text("Repayment amount")
                Text(viewModel.mortgageRepayment, format: .currency(code: "USD"))
                Chart {
                    BarMark(
                        x: .value("", ""), y: .value("Total amount", viewModel.chartData.principal), width: .ratio(0.85)
                    )
                    .foregroundStyle(by: .value("Principal", "Principal"))
                    BarMark(x: .value("", ""), y: .value("Interest", viewModel.chartData.interest), width: .ratio(0.85))
                        .foregroundStyle(by: .value("Interest", "Interest"))
                        .annotation {
                            Text(viewModel.chartData.formattedTotal ?? "").font(.title3).bold()
                        }
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
