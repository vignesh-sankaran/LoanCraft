//
//  TotalChart.swift
//  LoanCraft
//
//  Created by Vignesh Sankaran on 20/4/2025.
//

import Charts
import SwiftUI

struct TotalMortgageChart: View {
    @State var analytics = AnalyticsService.instance
    @State var overlayWidth: CGFloat = 100
    @State var overlayTextWidth: CGFloat = 0
    @State var selectedBar: SelectedBarItem?
    @Binding var chartData: ChartData

    var body: some View {
        Chart {
            BarMark(
                x: .value("", ""),
                y: .value("Total amount", chartData.principal),
                width: .ratio(0.85)
            )
            .foregroundStyle(by: .value("Principal", "Principal"))
            .accessibilityIdentifier("interest-bar-mark")
            BarMark(
                x: .value("", ""), y: .value("Interest", chartData.interest),
                width: .ratio(0.85)
            )
            .accessibilityIdentifier("interest-bar-mark")
            .foregroundStyle(by: .value("Interest", "Interest"))
            .annotation {
                SelectableTextField(
                    bold: true,
                    font: .title3,
                    text: .constant(chartData.total.currencyFormatted()),
                    type: .totalMortgage
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
                guard
                    let selectedBar = findSelectedBar(
                        location: value.location,
                        chartProxy: chartProxy
                    )
                else {
                    return
                }
                analytics.track(
                    selectedBar.trackingValue,
                    properties: ["overlayBeingShown": self.selectedBar != nil]
                )
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
                    let offsetY =
                        chartProxy.position(
                            forY: chartData.total
                        ) ?? 0

                    SelectableTextField(
                        bold: true,
                        font: .title3,
                        text: .constant(chartData.total.currencyFormatted()),
                        type: .totalMortgage
                    )
                    .position(x: offsetX, y: offsetY - 16)
                    .multilineTextAlignment(.center)
                }
                if let selectedBar {
                    let offsets = calculateOverlayOffsets(from: chartProxy)
                    ChartOverlay(
                        chartData: $chartData,
                        selectedBar: selectedBar,
                        textWidth: $overlayTextWidth
                    )
                    .background(
                        GeometryReader { geometryProxy in
                            Color.clear
                                .onAppear {
                                    overlayWidth = geometryProxy.size.width
                                }
                                .onChange(
                                    of: chartData.total
                                ) {
                                    overlayWidth = max(100, geometryProxy.size.width)
                                }
                        }
                    )
                    .offset(x: offsets.x, y: offsets.y)
                }
            }
        }
        .frame(height: 450)
        .sensoryFeedback(.selection, trigger: selectedBar)
    }
}
