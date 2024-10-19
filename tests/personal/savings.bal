import ballerina/io;
import ballerina/http;
import ballerina/mime;

// Define an HTTP listener to handle file uploads
listener http:Listener uploadListener = new (9090);

service /personalSavings on uploadListener {

    // Handle POST requests with PDF file upload
    resource function post upload(http:Caller caller, http:Request req) returns error? {
        // Extract the uploaded file
        mime:Entity|error bodyPart = req.getBodyParts();

        if bodyPart is mime:Entity[] {
            foreach var part in bodyPart {
                // Assuming we are getting the first file part
                if part.getContentDisposition()?.filename is string filename {
                    io:println("Uploaded file: " + filename);

                    // Assuming PDF content is extracted into text via an external service
                    string pdfContent = extractFinancialDataFromPDF(part);

                    // Parse financial data and calculate savings
                    decimal savings = calculatePersonalSavings(pdfContent);

                    // Respond with the calculated savings
                    json response = { "Personal Savings": savings };
                    check caller->respond(response);
                }
            }
        }
    }
}

// Hypothetical function that extracts financial data from the PDF content
// You will need to integrate a PDF parsing service or library for this step
function extractFinancialDataFromPDF(mime:Entity part) returns string {
    // Placeholder for PDF parsing logic
    // You can use a third-party service or library to extract structured data from the PDF
    return "Sample extracted PDF content with income and expenses data";
}

// Function to calculate personal savings from extracted financial data
function calculatePersonalSavings(string pdfContent) returns decimal {
    // Logic to parse the extracted content and compute personal savings
    // For simplicity, we'll assume pdfContent contains income and expenses in a parsable format
    // In real implementation, you need to extract income and expenses from pdfContent
    
    decimal totalIncome = extractIncomeFromContent(pdfContent);
    decimal totalExpenses = extractExpensesFromContent(pdfContent);

    // Calculate personal savings: Savings = Income - Expenses
    decimal personalSavings = totalIncome - totalExpenses;
    return personalSavings;
}

// Function to extract income from the parsed PDF content (stub implementation)
function extractIncomeFromContent(string content) returns decimal {
    // Example logic to extract income from content, replace with real parsing logic
    // For example, you might search for specific keywords in the text like "Income" or "Salary"
    return 5000; // Assume $5000 for this example
}

// Function to extract expenses from the parsed PDF content (stub implementation)
function extractExpensesFromContent(string content) returns decimal {
    // Example logic to extract expenses from content, replace with real parsing logic
    // For example, you might search for specific keywords like "Expenses" or "Spent"
    return 3000; // Assume $3000 for this example
}
