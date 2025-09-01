//
//  LoanCraftView.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import AmplitudeSessionReplay
import SwiftUI

struct LoanCraftView: View {
    @State var viewModel = LoanCraftViewModel()
    @FocusState var selectedTextField: SelectedTextField?
    @State var analytics = AnalyticsService.instance
    @State private var selectedChart = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Mortgage amount")
                        TextField(
                            "Mortgage amount", value: $viewModel.mortgage,
                            format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                        )
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    selectedTextField == .mortgageAmount
                                        ? Color.blue : Color("UnselectedFieldBorder"),
                                    lineWidth: selectedTextField == .mortgageAmount ? 2 : 0.5
                                )
                        )
                        .focused($selectedTextField, equals: .mortgageAmount)
                        .keyboardType(.numberPad)
                        .onChange(of: selectedTextField) { _, newValue in
                            if let newValue {
                                analytics.track(newValue.trackingValue)
                            }
                        }
                        .padding(.bottom, 16)
                        Text("Interest")
                        TextField("Interest", value: $viewModel.interest, format: .percent)
                            .textFieldStyle(.roundedBorder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedTextField == .interest
                                            ? Color.blue : Color("UnselectedFieldBorder"),
                                        lineWidth: selectedTextField == .interest ? 2 : 0.5
                                    )
                            )
                            .keyboardType(.decimalPad)
                            .focused($selectedTextField, equals: .interest)
                            .padding(.bottom, 16)
                        Text("Years remaining")
                        TextField(
                            "Years remaining", value: $viewModel.yearsRemaining, format: .number
                        )
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    selectedTextField == .yearsRemaining
                                        ? Color.blue : Color("UnselectedFieldBorder"),
                                    lineWidth: selectedTextField == .yearsRemaining ? 2 : 0.5
                                )
                        )
                        .keyboardType(.numberPad)
                        .focused($selectedTextField, equals: .yearsRemaining)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("Up", systemImage: "chevron.up") {
                                    analytics.track(.keyboardUpButtonTapped)
                                    selectedTextField = selectedTextField?.previous
                                }.fontWeight(.bold).disabled(selectedTextField == .mortgageAmount)
                                Button("Down", systemImage: "chevron.down") {
                                    analytics.track(.keyboardDownButtonTapped)
                                    selectedTextField = selectedTextField?.next
                                }.fontWeight(.bold).disabled(selectedTextField == .yearsRemaining)
                                Spacer()
                                Button("Done") {
                                    analytics.track(.doneButtonTapped)
                                    hideKeyboard()
                                }.bold()
                            }
                        }
                        .padding(.bottom, 16)
                        Text("Repayment frequency")
                        Picker("Repayment frequency", selection: $viewModel.repaymentFrequency) {
                            Text("Weekly").tag(RepaymentFrequency.week)
                            Text("Fortnightly").tag(RepaymentFrequency.fortnight)
                            Text("Monthly").tag(RepaymentFrequency.month)
                            Text("Yearly").tag(RepaymentFrequency.year)
                        }
                        .pickerStyle(.segmented)
                        .sensoryFeedback(.selection, trigger: viewModel.repaymentFrequency)
                        .padding(.bottom, 16)
                        .onChange(of: viewModel.repaymentFrequency) { _, newValue in
                            analytics.track(
                                .repaymentFrequencySlider,
                                properties: ["selectedFrequency": newValue.rawValue]
                            )
                        }
                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {
                            Text("Repayment amount per \(viewModel.repaymentFrequency.rawValue):")
                                .bold()
                            SelectableTextField(
                                text: .constant(viewModel.mortgageRepayment.currencyFormatted()),
                                type: .mortgagePayment
                            )
                            .offset(x: -5)
                            .padding(.bottom, 16)
                        }
                    }
                    .background(
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard selectedTextField == nil else { return }
                                hideKeyboard()
                            }
                    )
                    Picker("Chart Type", selection: $selectedChart) {
                        Text("Overview").tag(0)
                        Text("Total").tag(1)
                    }
                    .sensoryFeedback(.selection, trigger: selectedChart)
                    .pickerStyle(.segmented)
                    .padding(.vertical)
                    TabView(selection: $selectedChart) {
                        VStack {
                            Spacer(minLength: 48)
                            AmortisationChart()
                                .environment(viewModel)
                                .id(viewModel.mortgageRepayment)
                        }
                        .padding([.leading], 4)
                        .tag(0)
                        VStack {
                            TotalMortgageChart()
                                .environment(viewModel)
                                .id(viewModel.mortgageRepayment)
                        }
                        .tag(1)
                    }
                    .tabViewStyle(.automatic)
                    .indexViewStyle(.page(backgroundDisplayMode: .never))
                    .frame(
                        height: 600,
                        alignment: .top
                    )
                }
                .textFieldStyle(.roundedBorder)
                .padding()
            }
            .navigationTitle("LoanCraft")
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
        .onAppear {
            viewModel.calculateMortgageRepayment()
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(
                UIResponder.resignFirstResponder
            ),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoanCraftView()
    }
}
