//
//  ContentView.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import Charts
import Foundation
import SwiftUI

struct NestView: View {
    @State var viewModel = ViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Mortgage amount")
                    TextField(
                        "Mortgage amount", value: $viewModel.mortgage,
                        format: .currency(code: "AUD")
                    )
                    .keyboardType(.numberPad)
                    .padding(.bottom, 16)
                    Text("Interest")
                    TextField("Interest", value: $viewModel.interest, format: .percent)
                        .keyboardType(
                            .decimalPad)
                        .padding(.bottom, 16)
                    Text("Years remaining")
                    TextField("Years remaining", value: $viewModel.yearsRemaining, format: .number)
                        .keyboardType(.numberPad)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("Left", systemImage: "chevron.left") {}
                                Button("Right", systemImage: "chevron.right") {}
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    // Set up saving of value if on focus, then off focus has a 0, empty, or invalid value
                    Text("Repayment frequency")
                    Picker("Repayment frequency", selection: $viewModel.repaymentFrequency) {
                        Text("Weekly").tag(52)
                        Text("Fortnightly").tag(26)
                        Text("Monthly").tag(12)
                        Text("Yearly").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .sensoryFeedback(.selection, trigger: viewModel.repaymentFrequency)
                    .padding(.bottom, 16)
                    Text("Repayment amount per period:").bold()
                    Text(viewModel.mortgageRepayment, format: .currency(code: "AUD")).padding(.bottom, 32)
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
                    }.frame(height: 400)
                }
                .textFieldStyle(.roundedBorder)
                .padding()
            }
            .navigationTitle("HomeCalc")
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NestView()
    }
}
