import ballerinax/mongodb;
import ballerina/io;


public function info(string data, int stepCode) {
    if (stepCode == 1) {
        io:println("[Clarifi-System-Info: InitStep] " + data);
    }
    else if (stepCode == 2) {
        io:println("[Clarifi-System-Info: CreateStep] " + data);
    }
    else if (stepCode == 3) {
        io:println("[Clarifi-System-Info: InsertStep] " + data);
    }
    else if (stepCode == 4){
        io:println("[Clarifi-System-Info: ScriptFinished | Hello World From Clarifi] " + data);
    } else {
        io:println("[Clarifi-System-Info]" + data);
    }
}

public function main() returns error? {
    info("Database Initialization...", 1);
    info("Connecting to MongoDB", 1);
    
    mongodb:Client mongoDb = check new ({
        connection: {
            serverAddress: {
                host: "localhost",
                port: 27017
            }
        }
    });

    info("Init Done", 1);

    info("Creating Database 'clarifi'", 2);
    mongodb:Database db = check mongoDb->getDatabase("clarifi");


    info("Creating tables...", 2);
    string[7] tables = ["users", "admins", "income", "expenses", "assets", "liabilities", "capital"];
    foreach string createTable in tables {
        check db->createCollection(createTable);
        info("Table " + createTable + " created",100);
    }

    mongodb:Collection adminTable = check db->getCollection("admins");


    info("Updating tables...", 3);
    map<anydata> adminTableData = {
        "adminUserID": "admin",
        "adminUserPasswd": "admin"
    };
    check adminTable->insertOne(adminTableData);

    info("Script Reached End !", 4);
}
