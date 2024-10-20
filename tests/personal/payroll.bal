// taken montly (salary of all yhe workers individually are taken) 
import ballerina/io;
import ballerina/file;
import ballerina/mime;
import ballerina/pdf;
import ballerina/http;

service / on new http:Listener(8080) {

    resource function post payroll(http:Caller caller, http:Request req) returns error? {
        // Extract the PDF file from the request
        mime:Entity entity = check req.getBodyAsEntity();
        byte[] pdfContent = check entity.getByteArray();

        // Save the PDF file locally
        string pdfFilePath = "./uploaded_payroll.pdf";
        check file:writeBytes(pdfFilePath, pdfContent);

        // Process the PDF to extract payroll information
        map<string> payrollData = processPayrollPDF(pdfFilePath);

        // Generate the financial report
        string report = generateFinancialReport(payrollData);

        // Send the report back to the user
        check caller->respond(report);
    }
}

function processPayrollPDF(string pdfFilePath) returns map<string> {
    // Placeholder function to process the PDF and extract payroll information
    // Implement the actual PDF processing logic here
    map<string> payrollData = {};
    payrollData["employee1"] = "1000";
    payrollData["employee2"] = "1500";
    return payrollData;
}
// i did only this part
function generateFinancialReport(map<string> payrollData) returns string {
    // this done monthly and to each and every employee
 decimal basicSalary;
 decimal bonuses;
 decimal overtime;
 decimal taxRate;
 decimal insuranceRate;
    

// formula
decimal grossSalary = basicSalary + bonuses + overtime;
decimal tax = grossSalary * (taxRate / 100);
decimal insurance = grossSalary * (insuranceRate /100);
decimal netSalary = grossSalary -(tax + insurance) ;



    string report = "Financial Report:\n";
    foreach var [employee, salary] in payrollData.entries() {
        report += employee + ": $" + salary + "\n";
    }
    return report;
}