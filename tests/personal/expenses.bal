import ballerina/io;
import ballerina/http;
import ballerina/mime;

// Define an HTTP listener to handle file uploads
listener http:Listener uploadListener = new (9090);

service /personalExpense on uploadListener {

    // Handle POST requests with PDF file upload
    resource function post upload(http:Caller caller, http:Request req) returns error? {
        // Extract the uploaded file
        mime:Entity[]|http:ClientError bodyPart = req.getBodyParts();

        if bodyPart is mime:Entity[] {
            foreach var part in bodyPart {
                // Assuming we are getting the first file part
                if part.getContentDisposition()?.filename is string filename {
                    io:println("Uploaded file: " + filename);

                    // Assuming PDF content is extracted into text via an external service
                    string pdfContent = extractExpenseDataFromPDF(part);

                    // Calculate personal expenses from extracted PDF content
                    decimal totalExpenses = calculatePersonalExpenses(pdfContent);

                    // Send the total expenses as response
                    json response = { "TotalExpenses": totalExpenses };
                    check caller->respond(response);
                }
            }
        }
    }
}

// Hypothetical function to extract expense data from the PDF content
// In a real-world use case, you would integrate with a PDF parsing service or library
function extractExpenseDataFromPDF(mime:Entity part) returns string {
    // Placeholder for PDF parsing logic, return sample text
    // You would replace this with actual PDF parsing and data extraction logic
    return "Sample extracted PDF content with expenses";
}

// Function to calculate total personal expenses from extracted PDF text
function calculatePersonalExpenses(string pdfContent) returns decimal {
    // Here, parse the extracted content for personal expenses and calculate total
    // For simplicity, we'll return some dummy data for now
    decimal rent ;
    decimal groceries ;
    decimal utilities ;
    decimal entertainment;

    decimal totalExpenses = rent + groceries + utilities + entertainment;
    return totalExpenses;
}
