//
//  LoanCraftView.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import AmplitudeSessionReplay
import Charts
import SwiftUI

struct LoanCraftView: View {
    @State var viewModel = ViewModel()
    @State var selectedBar: SelectedBarItem?
    @FocusState var selectedTextField: SelectedTextField?
    let analytics = AnalyticsService()
    @State var overlayWidth: CGFloat = 100
    @State var selection: TextSelection?

    var body: some View {
        NavigationStack {
            ScrollView {
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
                                selectedTextField == .mortgageAmount ? Color.blue : Color("UnselectedFieldBorder"),
                                lineWidth: selectedTextField == .mortgageAmount ? 2 : 0.5
                            )
                    )
                    .focused($selectedTextField, equals: .mortgageAmount)
                    .keyboardType(.numberPad)
                    .onChange(of: selectedTextField) { _, newValue in
                        if let newValue {
                            analytics.send(event: newValue.trackingValue)
                        }
                    }
                    .padding(.bottom, 16)
                    Text("Interest")
                    TextField("Interest", value: $viewModel.interest, format: .percent)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    selectedTextField == .interest ? Color.blue : Color("UnselectedFieldBorder"),
                                    lineWidth: selectedTextField == .interest ? 2 : 0.5
                                )
                        )
                        .keyboardType(.decimalPad)
                        .focused($selectedTextField, equals: .interest)
                        .padding(.bottom, 16)
                    Text("Years remaining")
                    TextField("Years remaining", value: $viewModel.yearsRemaining, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    selectedTextField ==    .yearsRemaining ? Color.blue : Color("UnselectedFieldBorder"),
                                    lineWidth: selectedTextField == .yearsRemaining ? 2 : 0.5
                                )
                        )
                        .keyboardType(.numberPad)
                        .focused($selectedTextField, equals: .yearsRemaining)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("Up", systemImage: "chevron.up") {
                                    analytics.send(event: .keyboardUpButtonTapped)
                                    selectedTextField = selectedTextField?.previous
                                }.fontWeight(.bold).disabled(selectedTextField == .mortgageAmount)
                                Button("Down", systemImage: "chevron.down") {
                                    analytics.send(event: .keyboardDownButtonTapped)
                                    selectedTextField = selectedTextField?.next
                                }.fontWeight(.bold).disabled(selectedTextField == .yearsRemaining)
                                Spacer()
                                Button("Done") {
                                    analytics.send(event: .doneButtonTapped)
                                    hideKeyboard()
                                }.bold()
                            }
                        }
                        .padding(.bottom, 16)
                    // Set up saving of value if on focus, then off focus has a 0, empty, or invalid value
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
                        analytics.send(
                            event: .repaymentFrequencySlider,
                            properties: ["selectedFrequency": newValue.rawValue]
                        )
                    }
                    Text("Repayment amount per \(viewModel.repaymentFrequency.rawValue):").bold()
                    SelectableText(
                        text: $viewModel.formattedMortgagePayment
                    )
                    .offset(x: -5)
                    .padding(.bottom, 16)
                    Chart {
                        BarMark(
                            x: .value("", ""),
                            y: .value("Total amount", viewModel.chartData.principal),
                            width: .ratio(0.85)
                        )
                        .foregroundStyle(by: .value("Principal", "Principal"))
                        .accessibilityIdentifier("interest-bar-mark")
                        BarMark(
                            x: .value("", ""), y: .value("Interest", viewModel.chartData.interest),
                            width: .ratio(0.85)
                        )
                        .accessibilityIdentifier("interest-bar-mark")
                        .foregroundStyle(by: .value("Interest", "Interest"))
                        .annotation {
                            SelectableText(
                                bold: true,
                                font: .title3,
                                text: .constant(viewModel.chartData.formattedTotal ?? "")
                            )
                            .multilineTextAlignment(.center)
                            .hidden()
                        }
                    }
                    .chartForegroundStyleScale(
                        [
                            "Principal": Color("Principal"),
                            "Interest": Color("Interest"),
                        ]
                    )
                    .chartLegend(position: .bottom) {
                        HStack(spacing: 16) {
                            HStack {
                                BasicChartSymbolShape.circle
                                    .foregroundColor(Color("Principal"))
                                    .frame(width: 8, height: 8)
                                Text("Principal")
                                    .foregroundColor(Color(uiColor: .gray))
                            }
                            HStack {
                                BasicChartSymbolShape.circle
                                    .foregroundColor(Color("Interest"))
                                    .frame(width: 8, height: 8)
                                Text("Interest")
                                    .foregroundColor(Color(uiColor: .gray))
                            }
                        }
                        .padding()
                    }
                    .chartGesture { chartProxy in
                        SpatialTapGesture().onEnded { value in
                            guard let selectedBar = findSelectedBar(
                                location: value.location, chartProxy: chartProxy)
                            else { return }
                            analytics.send(
                                event: selectedBar.trackingValue,
                                properties: ["overlayBeingShown": self.selectedBar != nil])
                            if self.selectedBar == selectedBar {
                                self.selectedBar = nil
                            } else {
                                self.selectedBar = selectedBar
                            }
                        }
                    }
                    .chartOverlay { chartProxy in
                        GeometryReader { geometryProxy in
                            if let chartProxyPlotFrame = chartProxy.plotFrame {
                                let plotFrame = geometryProxy[chartProxyPlotFrame]
                                let offsetX = plotFrame.midX
                                let offsetY = chartProxy.position(
                                    forY: self.viewModel.chartData.total
                                ) ?? 0
                
                                SelectableText(
                                    bold: true,
                                    font: .title3,
                                    text: .constant(viewModel.chartData.formattedTotal ?? "")
                                )
                                .position(x: offsetX, y: offsetY - 8)
                                .multilineTextAlignment(.center)
                            }
                            if let selectedBar {
                                let offsets = calculateOverlayOffsets(from: chartProxy)
                                VStack(alignment: .center) {
                                    if selectedBar == .principal {
                                        Text("Principal:").font(.headline)
                                        SelectableText(
                                            text: .constant(viewModel.chartData.formattedPrincipal ?? "")
                                        )
                                        .multilineTextAlignment(.center)
                                    } else if selectedBar == .interest {
                                        Text("Interest:").font(.headline)
                                        SelectableText(
                                            text: .constant(viewModel.chartData.formattedInterest ?? "")
                                        )
                                        .multilineTextAlignment(.center)
                                    }
                                }
                                .background(GeometryReader { geometryProxy in
                                    Color.clear
                                        .onAppear {
                                            self.overlayWidth = geometryProxy.size.width
                                        }
                                })
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
                                .offset(x: offsets.x, y: offsets.y)
                            }
                        }
                    }
                    .frame(height: 450)
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
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoanCraftView()
    }
}
