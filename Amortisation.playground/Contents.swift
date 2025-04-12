import Foundation

struct AmortizationSchedule {
    let month: Int
    let totalPayment: Double
    let principal: Double
    let interest: Double
    let remainingBalance: Double
}

func calculateAmortizationSchedule(
    loanAmount: Double, annualInterestRate: Double, loanTermYears: Int
) -> [AmortizationSchedule] {
    // Convert inputs
    let monthlyInterestRate = annualInterestRate / 12 / 100  // Convert annual rate to monthly decimal
    let totalPayments = loanTermYears * 12  // Total number of months

    // Calculate the fixed monthly payment using the formula
    let monthlyPayment =
        loanAmount * (monthlyInterestRate * pow(1 + monthlyInterestRate, Double(totalPayments)))
        / (pow(1 + monthlyInterestRate, Double(totalPayments)) - 1)

    var remainingBalance = loanAmount
    var schedule: [AmortizationSchedule] = []

    // Generate the amortization schedule
    for month in 1...totalPayments {
        let interestPayment = remainingBalance * monthlyInterestRate
        let principalPayment = monthlyPayment - interestPayment
        remainingBalance -= principalPayment

        // Ensure no negative balance due to rounding errors in the last payment
        if remainingBalance < 0 {
            remainingBalance = 0
        }

        // Add this month's details to the schedule
        schedule.append(
            AmortizationSchedule(
                month: month,
                totalPayment: monthlyPayment,
                principal: principalPayment,
                interest: interestPayment,
                remainingBalance: remainingBalance
            ))
    }

    return schedule
}

// Example Usage:
let loanAmount = 500_000.0  // $500,000 loan amount
let annualInterestRate = 6.0  // 6% annual interest rate
let loanTermYears = 30  // 30-year loan term

let schedule = calculateAmortizationSchedule(
    loanAmount: loanAmount, annualInterestRate: annualInterestRate, loanTermYears: loanTermYears)

// Print the amortization schedule
for entry in schedule {
    print(
        "Month \(entry.month): Total Payment: \(String(format: "%.2f", entry.totalPayment)), Principal: \(String(format: "%.2f", entry.principal)), Interest: \(String(format: "%.2f", entry.interest)), Remaining Balance: \(String(format: "%.2f", entry.remainingBalance))"
    )
}
