import ballerina/io;
import ballerina/http;
import ballerina/mime;

// Define an HTTP listener to handle file uploads
listener http:Listener uploadListener = new (9090);

service /personalIncomeTrack on uploadListener {

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
                    // This function assumes the PDF is parsed and we get the raw text content
                    string pdfContent = extractPersonalIncomeDataFromPDF(part);

                    // Calculate personal income from extracted PDF content
                    decimal personalIncome = calculatePersonalIncome(pdfContent);

                    // Send the calculated personal income as response
                    json response = {
                        "TotalPersonalIncome": personalIncome
                    };
                    check caller->respond(response);
                }
            }
        }
    }
}

// Hypothetical function that extracts personal income data from the PDF content
// In real use, you would integrate with a PDF parsing service or library
function extractPersonalIncomeDataFromPDF(mime:Entity part) returns string {
    // Placeholder for PDF parsing logic, return some sample text
    // This is where you would use an external library or API to extract data
    return "Salary: 5000, Investments: 1500, Other: 500";
}

// Function to calculate total personal income from extracted text
function calculatePersonalIncome(string pdfContent) returns decimal {
    // Placeholder for parsing logic
    // For simplicity, assume the text contains comma-separated income sources
    // In a real application, you'd parse this data properly

    // Sample data parsing: "Salary: 5000, Investments: 1500, Other: 500"
    decimal salary ;
    decimal investments ;
    decimal otherIncome ;

    // Calculate total personal income
    return salary + investments + otherIncome;
}
