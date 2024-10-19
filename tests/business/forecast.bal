// results are given in months so it can be more accurate
import ballerina/io;
import ballerina/file;
import ballerina/mime;
import ballerina/http;

service / on new http:Listener(8080) {

    resource function post forecast(http:Caller caller, http:Request req) returns error? {
        // Check if the request has a file
        http:Part[] parts =  check req.getBodyParts();
        if parts.length() > 0 {
            // Get the file part from the request
            http:Part filePart = parts[0];
            if filePart is http:Part {
                // Save the uploaded file
                string filePath = "./uploaded/" + filePart.filename;
                check filePart.writeToFile(filePath);

                // Process the PDF file
                string forecast = check processPDF(filePath);

                // Send the forecast as the response
                check caller->respond(forecast);
            }
        } else {
            check caller->respond("No file uploaded");
        }
    }
}

function processPDF(string filePath) returns string|error {
    // Open the PDF document
    pdf:Document pdfDoc = check pdf:openDocument(filePath);

    // Extract text from the PDF
    string text = check pdfDoc.getText();

    // Close the PDF document
    check pdfDoc.close();

    // Generate a financial forecast based on the extracted text
    string forecast = generateForecast(text);

    return forecast;
}

function generateForecast(string text) returns string {
    // formula 
    // it should be done in monthwise
    decimal  incashflow;
    decimal  outcashflow;

     decimal cashflow = incashflow +outcashflow;
    return "Financial forecast based on the uploaded PDF: " + text;
}