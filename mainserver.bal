import ballerina/io;
import ballerina/http;
import ballerinax/mongodb;
import ballerina/mime;

public class DatabaseConn {
    public string hostname = "localhost";
    public int port = 27017;
    json document = {};
    public string collectionName = "";
    public string dbNameStr = "";
    public mongodb:Collection? collection = ();

    public function initDB(string hostname, int port, json document, string dbNameStr, string collectionName) returns error? {
        self.hostname = hostname;
        self.port = port;
        self.document = document;
        mongodb:Client mongoDb = check self.connectDB();
        mongodb:Database dbName = check mongoDb->getDatabase(dbNameStr);
        var collectionResult = dbName->getCollection(collectionName);
        if (collectionResult is mongodb:Collection) {
            self.collection = collectionResult;
            record {| anydata...; |} docRecord = check document.cloneWithType();
            check collectionResult->insertOne(docRecord);
        } else {
            return collectionResult;
        }
        return ();
    }

    public function connectDB() returns mongodb:Client|error {
        mongodb:Client mongoDb = check new ({
            connection: {
                serverAddress: {
                    host: self.hostname,
                    port: self.port
                }
            }
        });
        return mongoDb;
    }

    // Function to retrieve data from the collection based on filter criteria
    public function retrieveData(string dbNameStr, string collectionName ) returns json[]|error {
        mongodb:Client mongoDb = check self.connectDB();
        mongodb:Database dbName = check mongoDb->getDatabase(dbNameStr);
        var collectionResult = dbName->getCollection(collectionName);
        if (collectionResult is mongodb:Collection) {
            map<json> query = {};
            stream<record {| anydata...; |}, error?> docStream = check collectionResult->find(query);
            json[] retrievedDocs = [];
            check from record {| anydata...; |} doc in docStream
                do {
                    retrievedDocs.push(doc.toJson());
                };
            io:println("Retrieved Documents: ");
            io:println(retrievedDocs.toString());
            return retrievedDocs;
        } else {
            io:println("Collection not found");
            return [];
        }
    }
}

public class syslog {
    public function loginfo(string data) {
        io:println("[Clarifi-System-Info] " + data);
    }
}

// Service to handle HTTP requests
service / on new http:Listener(8080) {

    // Resource to handle POST requests for inserting data
    resource function post jsonInput(http:Caller caller, http:Request req) returns error? {
        syslog info = new syslog();
        info.loginfo("Received HTTP POST request.");

        json payload = check req.getJsonPayload();
        info.loginfo("Extracted JSON payload: " + payload.toString());

        string payloadToString = payload.toString();
        info.loginfo("Payload to string: " + payloadToString);

        json parsedData = check payloadToString.fromJsonString();
        io:println(parsedData);
        string[7] collections = ["users", "admins", "income", "expenses", "assets", "liabilities", "capital"];
        string collectionName = check parsedData.collectionName;
        string dbName = check parsedData.dbName;
        json updateData = check parsedData.data;

        foreach string stuff in collections {
            if (stuff == collectionName.toString()) {
                info.loginfo("Collection name found: " + collectionName);
                DatabaseConn dbConn = new DatabaseConn();
                string dbNameStr = dbName.toString();
                check dbConn.initDB("localhost", 27017, updateData, dbNameStr, collectionName);
            }
        }

        json response = {status: "success", message: "Data inserted successfully", data: payload};
        check caller->respond(response);
    }

    resource function get getData(http:Caller caller, http:Request req) returns error? {
        syslog info = new syslog();
        json response = {};
        info.loginfo("Received HTTP GET request.");
        string[7] collections = ["users", "admins", "income", "expenses", "assets", "liabilities", "capital"];

        json payload = check req.getJsonPayload();
        string payloadToString = payload.toString();
        json parsedData = check payloadToString.fromJsonString();

        string collectionName = check parsedData.collectionName;
        string dbName = check parsedData.dbName;

        io:println("Collection Name: " + collectionName);

        boolean collectionFound = false;
        foreach string stuff in collections {
            if (stuff == collectionName.toString()) {
                if (collectionName.toString() == "users") {
                    string email = check parsedData.email;
                    string emailStr = email.toString();
                    info.loginfo("Email: " + emailStr);
                    DatabaseConn dbConn = new DatabaseConn();
                    string dbNameStr = dbName.toString();
                    json[] listResult = check dbConn.retrieveData(dbNameStr, collectionName);
                }
                info.loginfo("Collection Found: " + collectionName);
                DatabaseConn dbConn = new DatabaseConn();
                string dbNameStr = dbName.toString();
                json[] listResult = check dbConn.retrieveData(dbNameStr, collectionName);
                string result = listResult.toString();
                io:println("Result: " + result);
                response = {status: "success", message: "Data retrieved successfully", data: result};
                collectionFound = true;
                break; // Exit loop when collection is found
            }
        }

        if (!collectionFound) {
            response = {status: "failure", message: "Collection not found"};
        }
        check caller->respond(response);
    }

    // Resource to handle GET requests to display the index.html
    resource function get .(http:Caller caller, http:Request req) returns error? {
        syslog info = new syslog();
        info.loginfo("Serving index.html from the app folder.");

        string pathToFile = "./app/index.html";
        mime:Entity entity = new;
        entity.setFileAsEntityBody(pathToFile, contentType = mime:TEXT_HTML);
        http:Response response = new;
        response.setEntity(entity);
        check caller->respond(response);
    }

    resource function get signup(http:Caller caller, http:Request req) returns error? {
        syslog info = new syslog();
        string pathToFile = "./app/signup.html";
        mime:Entity entity = new;
        entity.setFileAsEntityBody(pathToFile, contentType = mime:TEXT_HTML);
        http:Response response = new;
        response.setEntity(entity);
        check caller->respond(response);
    }

    resource function get login(http:Caller caller, http:Request req) returns error? {
        syslog info = new syslog();
        string pathToFile = "./app/login.html";
        mime:Entity entity = new;
        entity.setFileAsEntityBody(pathToFile, contentType = mime:TEXT_HTML);
        http:Response response = new;
        response.setEntity(entity);
        check caller->respond(response);
    }


}

public function main() returns error? {
    io:println("\n\n");
    io:println(" #####  #          #    ######  ### ####### ### \n" +
               "#     # #         # #   #     #  #  #        #  \n" +
               "#       #        #   #  #     #  #  #        #  \n" +
               "#       #       #     # ######   #  #####    #  \n" +
               "#       #       ####### #   #    #  #        #  \n" +
               "#     # #       #     # #    #   #  #        #  \n" +
               " #####  ####### #     # #     # ### #       ###  \n" +
               " System Server");

    syslog info = new syslog();
    info.loginfo("Initializing Database Connection...");
    info.loginfo("Checking Database Connection...");
    DatabaseConn dbConn = new DatabaseConn();
    info.loginfo("HTTP Server is running on port 8080.");

    return ();
}
