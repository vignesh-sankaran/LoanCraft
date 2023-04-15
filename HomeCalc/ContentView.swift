//
//  ContentView.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 7/4/2023.
//

import SwiftUI

struct ContentView: View {
    @State var mortgage = ""
    @State var interest = ""
    @State var yearsRemaining = ""
    @State var repaymentFrequency: Int = 26
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Mortgage amount")
                TextField("Mortgage amount", text: $mortgage)
            }
            HStack {
                Text("Interest")
                TextField("Interest", text: $interest)
            }
            HStack {
                Text("Years remaining")
                TextField("Years remaining", text: $yearsRemaining)
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
