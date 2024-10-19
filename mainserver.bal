import ballerina/io;
import ballerina/http;
import ballerinax/mongodb;
//  import ballerina/regex;
//  import ballerina/lang.value;

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
        // Convert json to a record type
        record {| anydata...; |} docRecord = check document.cloneWithType();
        // add record to collection
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
}

public class syslog {
    public function loginfo(string data) {
        io:println("[Clarifi-System-Info] " + data);
    }
}

// HTTP service to listen for JSON inputs
service / on new http:Listener(8080) {

    resource function post jsonInput(http:Caller caller, http:Request req) returns error? {
        syslog info = new syslog();
        info.loginfo("Received HTTP request.");

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
                info.loginfo("Collection name found:"+ collectionName);
                DatabaseConn dbConn = new DatabaseConn();
                //io:println(updateData);
                //map<any> document = updateData;
                string dbNameStr = dbName.toString();
                //io:println(dbNameStr);
                check dbConn.initDB("localhost", 27017, updateData, dbNameStr, collectionName);
            }
        }

        json response = {status: "success", message: "JSON received", data: payload};
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
    DatabaseConn dbConn = new DatabaseConn();
    // check dbConn.initDB("localhost", 27017, {}, "clarifi", "users");
    info.loginfo("HTTP Server is running on port 8080.");

    return ();
}
