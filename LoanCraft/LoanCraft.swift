//
//  ContentView.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import Charts
import Foundation
import SwiftUI

enum SelectedBarItem {
    case interest, principal
}

struct LoanCraft: View {
    @State var viewModel = ViewModel()
    @State var selectedBar: SelectedBarItem?

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
                    }
                    .chartGesture { chartProxy in
                        SpatialTapGesture().onEnded { value in
                            let selectedBar = findSelectedBar(location: value.location, chartProxy: chartProxy)
                            if self.selectedBar == selectedBar {
                                self.selectedBar = nil
                            } else {
                                self.selectedBar = selectedBar
                            }
                        }
                    }
                    .chartOverlay { chartProxy in
                        if let selectedBar {
                            GeometryReader { geometryProxy in
                                // get y coordinate to offset by
                                let offset = (chartProxy.plotSize.width / 2) - 50
                                VStack {
                                    if selectedBar == .principal {
                                        Text("Principal: \(viewModel.chartData.formattedPrincipal ?? "")")
                                    } else if selectedBar == .interest {
                                        Text("Interest: \(viewModel.chartData.formattedInterest ?? "")")
                                    }
                                }
                                .frame(width: 100, alignment: .center)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.background)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.quaternary.opacity(0.7))
                                    }
                                    .padding(.horizontal, -8)
                                    .padding(.vertical, -4)
                                }
                                .offset(x: offset, y: 100)
                            }
                        }
                    }
                    .frame(height: 400)
                    .sensoryFeedback(.selection, trigger: selectedBar)
                }
                .textFieldStyle(.roundedBorder)
                .padding()
            }
            .navigationTitle("LoanCraft")
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func findSelectedBar(
        location: CGPoint,
        chartProxy: ChartProxy
    ) -> SelectedBarItem? {
        guard let value = chartProxy.value(atY: location.y) as Decimal? else {
            return nil
        }

        if value <= viewModel.chartData.principal {
            return .principal
        } else if value <= viewModel.chartData.total {
            return .interest
        } else {
            return nil
        }
    }
    
    // Create new function here to handle different haptic feedback gestures
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoanCraft()
    }
}
