import ballerina/io;
import ballerina/http;
import ballerina/mime;
import ballerina/file;
import ballerina/pdf;

// Define an HTTP listener to handle file uploads
listener http:Listener uploadListener = new (9090);

service /financialReport on uploadListener {

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
                    // Here you can integrate a PDF extraction service and pass `part`
                    // This function assumes the PDF is parsed and we get the raw text content
                    string pdfContent = extractFinancialDataFromPDF(part);

                    // Generate financial statement from extracted PDF content
                    FinancialStatement financialStatement = generateFinancialStatement(pdfContent);

                    // Send financial statement as response
                    json response = {
                        
                    };
                    check caller->respond(response);
                }
            }
        }
    }
}

// Hypothetical function that extracts financial data from the PDF content
// In real use, you would integrate with a PDF parsing service or library
function extractFinancialDataFromPDF(mime:Entity part) returns string {
    // Placeholder for PDF parsing logic, return some sample text
    // This is where you would use an external library or API to extract data
    return "Sample extracted PDF content with financial data";
}
// i did only this part
// Record to represent the financial statement
type FinancialStatement record {
    decimal sales ;
    decimal costOfSales;
    decimal netprofit;
    decimal actualprofit;
};

// Function to generate the financial statement from extracted text
function generateFinancialStatement(string pdfContent) returns FinancialStatement {
    //formula
    decimal sales;
    decimal salesReturn;
    decimal openingInventory;
    decimal closingInventory;
    decimal purchases;
    decimal purchasesReturn;
    decimal income;
    decimal expense;
    decimal taxrate;
    decimal vat;

    decimal costOfSales = openingInventory + (purchases - purchasesReturn) - closingInventory;
    decimal grossProfit = (sales - salesReturn) - costOfSales;

    decimal netprofit = (grossProfit + income) - expense;
    decimal tax = (taxrate/ 100);
    decimal actualprofit = (netprofit * taxrate )* (vat / 100);
    
    return {
      sales,
      costOfSales,
      netprofit,
      actualprofit, 
    };
