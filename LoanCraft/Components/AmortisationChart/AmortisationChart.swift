//
//  AmortisationChart.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 25/4/2025.
//

import Charts
import SwiftUI

struct AmortisationChart: View {
    @State private var featureFlagService = FeatureFlagService.instance
    @State var viewModel = AmortisationViewModel()
    @Environment(LoanCraftViewModel.self) private var loanCraftViewModel

    var body: some View {
        if featureFlagService.amortisationGraphEnabled {
            Chart {
                ForEach(viewModel.schedule) { amortisationData in
                    LineMark(
                        x: .value("Year", amortisationData.year),
                        y: .value("Remaining", amortisationData.remaining)
                    )
                    RuleMark(x: .value("Year", viewModel.selectedYear))
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 1))
                }
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
                                            viewModel.selectedYear = findElement(
                                                location: value.location, chartProxy: chartProxy,
                                                geometryProxy: gemoetryProxy
                                            )
                                        }
                                )
                        )
                }
            }
            .chartOverlay { chartProxy in
                GeometryReader { geometryProxy in
                    if let chartProxyPlotFrame = chartProxy.plotFrame {
                        let startPositionX1 = chartProxy.position(forX: viewModel.selectedYear) ?? 0

                        let lineX = startPositionX1 + geometryProxy[chartProxyPlotFrame].origin.x
                        let boxWidth: CGFloat = 100
                        let boxOffset = max(
                            0, min(geometryProxy.size.width - boxWidth, lineX - boxWidth / 2))

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
                        .padding(.top, 2)
                        .padding(.bottom, 4)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background.opacity(0.8))
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.quaternary.opacity(0.7))
                            }
                            .padding(.horizontal, -8)
                            .padding(.vertical, -4)
                        }
                        .offset(x: boxOffset)
                    }
                }
            }
            .frame(height: 350)
            .sensoryFeedback(
                .impact(
                    intensity: 0.4
                ),
                trigger: viewModel.selectedYear
            )
        }
    }
}
