//
//  ViewModel.swift
//  HomeCalc
//
//  Created by Vignesh Sankaran on 16/4/2023.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var mortgage = 0
    @Published var interest = 0.0
    @Published var yearsRemaining = 30
    @Published var repaymentFrequency = 26
}
