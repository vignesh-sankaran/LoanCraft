//
//  ContentView.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var mortgage = 0
    @State var interest = 0.0
    @State var yearsRemaining = 30
    @State var repaymentFrequency: Int = 26
    @State var viewModel = ViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Mortgage amount")
                TextField("Mortgage amount", value: $viewModel.mortgage, format: .currency(code: "USD")).keyboardType(.numberPad)
            }
            HStack {
                Text("Interest")
                TextField("Interest", value: $viewModel.interest, format: .percent).keyboardType(.decimalPad)
            }
            HStack {
                Text("Years remaining")
                TextField("Years remaining", value: $viewModel.yearsRemaining, format: .number).keyboardType(.numberPad)
            }
            HStack {
                Text("Repayment frequency")
                Picker("Repayment frequency", selection: $viewModel.repaymentFrequency) {
                    Text("Monthly").tag(12)
                    Text("Fortnightly").tag(26)
                }.pickerStyle(.segmented)
            }
            HStack {
                Text("Repayment amount")
                Text("$2000.00")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
