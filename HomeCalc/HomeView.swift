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
                Chart {
                    BarMark(
                        x: .value("", ""), y: .value("Total amount", viewModel.chartData.total), width: .ratio(0.85)
                    )
                    .foregroundStyle(by: .value("Principal", "Principal"))
                    BarMark(x: .value("", ""), y: .value("Interest", viewModel.chartData.interest), width: .ratio(0.85))
                        .foregroundStyle(by: .value("Interest", "Interest"))
                   
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
