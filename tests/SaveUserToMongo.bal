import ballerinax/mongodb;

public function saveUser() returns error? {
    mongodb:Client mongoDb = check new ({
        connection: {
            serverAddress: {
                host: "localhost",
                port: 27017
            }
        }
    });

    // Connect to the database
    mongodb:Database db = check mongoDb->getDatabase("testdb");
    mongodb:Collection collection = check db->getCollection("testcollection");

    // Create a document (use map<anydata> instead of mongodb:Document)
    map<anydata> document = {
        "name": "John Doe",
        "age": 20,
        "status": "active"
    };

    // Save the document
    check collection->insertOne(document);
}
