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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Mortgage amount")
                TextField("Mortgage amount", value: $mortgage, format: .currency(code: "USD")).keyboardType(.numberPad)
            }
            HStack {
                Text("Interest")
                TextField("Interest", value: $interest, format: .percent).keyboardType(.decimalPad)
            }
            HStack {
                Text("Years remaining")
                TextField("Years remaining", value: $yearsRemaining, format: .number).keyboardType(.numberPad)
            }
            HStack {
                Text("Repayment frequency")
                Picker("Repayment frequency", selection: $repaymentFrequency) {
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
