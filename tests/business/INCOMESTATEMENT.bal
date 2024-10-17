import ballerina/io;

public function main() {
    // gross profit
    io:println("Enter Sales amount: ");
    string salesStr = io:readln();
    decimal sales = check 'decimal:fromString(salesStr);
    
    io:println("Enter Sales Return amount: ");
    string salesReturnStr = io:readln();
    decimal salesReturn = check 'decimal:fromString(salesReturnStr);
    
    io:println("Enter Opening Inventory amount: ");
    string openingInventoryStr = io:readln();
    decimal openingInventory = check 'decimal:fromString(openingInventoryStr);
    
    io:println("Enter Purchases amount: ");
    string purchasesStr = io:readln();
    decimal purchases = check 'decimal:fromString(purchasesStr);
    
    io:println("Enter Purchases Return amount: ");
    string purchasesReturnStr = io:readln();
    decimal purchasesReturn = check 'decimal:fromString(purchasesReturnStr);
    
    io:println("Enter Closing Inventory amount: ");
    string closingInventoryStr = io:readln();
    decimal closingInventory = check 'decimal:fromString(closingInventoryStr);
    
    decimal costOfSales = openingInventory + (purchases - purchasesReturn) - closingInventory;
    decimal grossProfit = (sales - salesReturn) - costOfSales;

    //net profit
    io:println("Enter Income amount: ");
    string incomeStr = io:readln();
    decimal income = check 'decimal:fromString(incomeStr);

    io:println("Enter Expenses amount: ");
    string expensesStr = io:readln();
    decimal expenses = check 'decimal:fromString(expensesStr);

    io:println("Enter Tax amount: ");
    string taxStr = io:readln();
    decimal tax = check 'decimal:fromString(taxStr);

    io:println("Enter VAT amount: ");
    string vatStr = io:readln();
    decimal vat = check 'decimal:fromString(vatStr);

    decimal netprofit = (grossProfit + income) - expenses;
    decimal actualprofit = (netprofit- tax )- vat;
    



    //output
    io:println("Gross Profit: ", grossProfit);
    io:println("Net Profit: ", netprofit);
    io:println("Actual Profit: ", actualprofit);
    
  
}
