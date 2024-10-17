import ballerina/io;
import ballerinax/mongodb;

// Read configuration from the config file
configurable string host = ?;
configurable int port = ?;

function info(string data, int specialCode) {
    if (specialCode == 1) {
        io:println("[Clarifi-Backend | System Initialization] " + data);
    } else if (specialCode == 2) {
        io:println("[Clarifi-Backend-Create-Info] " + data);
    } else if (specialCode == 3) {
        io:println("[Clarifi-Backend-Insert-Info] " + data);
    } else if (specialCode == 4) {
        io:println("[Clarifi-Backend-Script-Info] " + data);
    } else {
        io:println("[Clarifi-Backend-Info] " + data);
    }
}

function connectToMongoDB() returns mongodb:Client|error {
    mongodb:Client mongoDb = check new ({
        connection: {
            serverAddress: {
                host: host,
                port: port
            }
        }
    });
    return mongoDb; // Explicitly return the mongoDb instance
}

public function main() returns error? {
    io:println(" #####  #          #    ######  ### ####### ### \n" +
               "#     # #         # #   #     #  #  #        #  \n" +
               "#       #        #   #  #     #  #  #        #  \n" +
               "#       #       #     # ######   #  #####    #  \n" +
               "#       #       ####### #   #    #  #        #  \n" +
               "#     # #       #     # #    #   #  #        #  \n" +
               " #####  ####### #     # #     # ### #       ###  \n" +
               " System Server");
    
    info("Clarifi System Server Initializing...", 1);
    info("Connecting to MongoDB", 1);
    
    // Handle error from the connection
    var connResult = connectToMongoDB();
    if (connResult is error) {
        io:println("Error connecting to MongoDB: " + connResult.message());
        return connResult; // Return the error
    }
    
    mongodb:Client mongoDbClient = <mongodb:Client> connResult;
    info("Init Done", 100);
    return ();
}
