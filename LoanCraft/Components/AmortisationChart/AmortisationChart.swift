//
//  AmortisationChart.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 25/4/2025.
//

import Charts
import SwiftUI

struct AmortisationChart: View {
    @State var viewModel = AmortisationViewModel()
    @Environment(LoanCraftViewModel.self) private var loanCraftViewModel

    var body: some View {
        Chart {
            ForEach(viewModel.schedule) { amortisationData in
                LineMark(
                    x: .value("Year", amortisationData.year),
                    y: .value("Remaining", amortisationData.remaining)
                )
                RuleMark(
                    x: .value(
                        "Year",
                        viewModel.selectedYear
                    )
                )
                .foregroundStyle(.red)
                .lineStyle(
                    StrokeStyle(
                        lineWidth: 1
                    )
                )
            }
            if let selectedData = viewModel.schedule.first(
                where: {
                    $0.year == viewModel.selectedYear
                }
            ) {
                PointMark(
                    x: .value("Year", selectedData.year),
                    y: .value("Remaining", selectedData.remaining)
                )
                .symbolSize(80)
                .foregroundStyle(.red)
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let decimalValue = value.as(Decimal.self) {
                        Text(
                            decimalValue.currencyFormatted(
                                maximumFractionDigits: 0
                            )
                        )
                    }
                }
            }
        }
        .chartXAxisLabel(
            position: .bottom,
            alignment: .center
        ) {
            Text("Years")
                .font(.headline)
        }
        .onAppear {
            viewModel.calculateSchedule(with: loanCraftViewModel)
        }
        .chartOverlay { chartProxy in
            GeometryReader { gemoetryProxy in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                viewModel.selectedYear = findElement(
                                    location: value.location, chartProxy: chartProxy,
                                    geometryProxy: gemoetryProxy
                                )
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        withAnimation(.easeInOut) {
                                            viewModel.selectedYear = findElement(
                                                location: value.location, chartProxy: chartProxy,
                                                geometryProxy: gemoetryProxy
                                            )
                                        }
                                    }
                            )
                    )
            }
        }
        .chartOverlay { chartProxy in
            GeometryReader { geometryProxy in
                if let chartProxyPlotFrame = chartProxy.plotFrame {
                    let startPositionX = chartProxy.position(forX: viewModel.selectedYear) ?? 0

                    let lineX = startPositionX + geometryProxy[chartProxyPlotFrame].origin.x
                    let overlayWidth: CGFloat = 115
                    let overlayOffset = max(
                        0,
                        min(
                            chartProxy.plotSize.width - overlayWidth, lineX - (overlayWidth / 2)
                        )
                    )
                    VStack(
                        alignment: .center,
                        spacing: 4
                    ) {
                        Text("Balance")
                            .font(.headline)
                        SelectableTextField(
                            text: .constant(
                                viewModel.principalRemaining
                            ),
                            type: .mortgagePayment
                        )
                        .multilineTextAlignment(.center)
                        Text("Years left")
                            .font(.headline)
                        SelectableTextField(
                            text: .constant(
                                viewModel.yearsRemaining
                            ),
                            type: .mortgagePayment
                        )
                        .multilineTextAlignment(.center)
                    }
                    .frame(width: overlayWidth)
                    .padding(.top, 2)
                    .padding(.bottom, 4)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.background.opacity(0.9))
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.quaternary.opacity(0.9))
                        }
                        .padding(.horizontal, -8)
                        .padding(.vertical, -4)
                    }
                    .offset(x: overlayOffset, y: -100)
                }
            }
        }
        .frame(height: 350)
        .sensoryFeedback(
            .impact(flexibility: .rigid),
            trigger: viewModel.selectedYear
        )
    }
}
