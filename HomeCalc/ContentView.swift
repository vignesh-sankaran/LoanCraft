//
//  ContentView.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import Combine
import Foundation
import SwiftUI

var anyCancellable: AnyCancellable?

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
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
            }
            .padding()
            .navigationTitle("HomeCalc")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
