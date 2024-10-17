import ballerina/io;

public function main() {
    // Example values
    decimal revenue = 1000000;
    decimal cogs = 400000;
    decimal operatingExpenses = 200000;
    decimal taxRate = 0.2;

    IncomeStatement incomeStatement = calculateIncomeStatement(revenue, cogs, operatingExpenses, taxRate);
    
    // Print the Income Statement
    printIncomeStatement(incomeStatement);
}

// Record to store the income statement
type IncomeStatement record {
    decimal revenue;
    decimal grossProfit;
    decimal operatingIncome;
    decimal netIncome;
};

// Function to calculate the income statement
function calculateIncomeStatement(decimal revenue, decimal cogs, decimal operatingExpenses, decimal taxRate) returns IncomeStatement {
    decimal grossProfit = revenue - cogs;
    decimal operatingIncome = grossProfit - operatingExpenses;
    decimal taxes = operatingIncome * taxRate;
    decimal netIncome = operatingIncome - taxes;

    return {
        revenue: revenue,
        grossProfit: grossProfit,
        operatingIncome: operatingIncome,
        netIncome: netIncome
    };
}

// Function to print the income statement
function printIncomeStatement(IncomeStatement incomeStatement) {
    io:println("Income Statement");
    io:println("----------------------------");
    io:println("Revenue: " + incomeStatement.revenue.toString());
    io:println("Gross Profit: " + incomeStatement.grossProfit.toString());
    io:println("Operating Income: " + incomeStatement.operatingIncome.toString());
    io:println("Net Income: " + incomeStatement.netIncome.toString());
}
