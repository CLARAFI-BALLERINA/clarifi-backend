import ballerina/io;
import ballerina/mime;
import ballerina/http;
import ballerina/file;
import ballerina/pdf;

service /cashbook on new http:Listener(8080) {

    resource function post report(http:Caller caller, http:Request req) returns error? {
        // Extract the PDF file from the request
        mime:Entity entity = req.getBodyParts()[0];
        byte[] pdfContent = check entity.getByteArray();

        // Save the PDF to a temporary file
        string tempFilePath = "./temp_cashbook.pdf";
        check file:writeBytes(tempFilePath, pdfContent);

        // Process the PDF and generate the cash book report
        string report = processPDF(tempFilePath);

        // Send the report back to the client
        check caller->respond(report);
    }
}

function processPDF(string filePath) returns string {
// i don't know how to this 
    // left side  (dr)
    // cash and bank that came into the business

    //right side (cr)
     // cash and bank that gone out from the business

     // the balance of dr and cr should be equal which means the largest amount represent both dr and cr
     // there is no claculation just need to mention which side is the largest and how ids the difference
     // format for that is  creidt / debit = balance c/d <difference>


    return "Cash Book Report: \n\n[Report content extracted from PDF]";
}