import ballerina/io;
import ballerinax/mongodb;

type Movie record {
    string title;
    int year;
};

public function main() returns error? {
    // Step 1: Initialize the MongoDB client with connection details
    mongodb:Client|error mongoDbResult = new ({
        connection: {
            serverAddress: {
                host: "localhost",
                port: 27017
            },
            auth: {
                username: "<username>", // Replace with your MongoDB username
                password: "<password>", // Replace with your MongoDB password
                database: "admin"       // Replace with your MongoDB admin database
            }
        }
    });

    // Check for errors while initializing the client
    if (mongoDbResult is mongodb:Client) {
        mongodb:Client mongoDb = mongoDbResult;

        // Step 2: Retrieve the database
        mongodb:Database|error dbResult = mongoDb->getDatabase("movies");
        if (dbResult is mongodb:Database) {
            mongodb:Database moviesDb = dbResult;

            // Step 3: Retrieve the collection
            mongodb:Collection|error collectionResult = moviesDb->getCollection("movies");
            if (collectionResult is mongodb:Collection) {
                mongodb:Collection moviesCollection = collectionResult;

                // Step 4: Insert a document
                Movie movie = {title: "Inception", year: 2010};
                error? insertResult = moviesCollection->insert(movie);
                if (insertResult is error) {
                    io:println("Failed to insert document: ", insertResult.message());
                    return insertResult;
                }
                io:println("Document inserted successfully!");

                // Optional: Retrieve the inserted document to verify
                bson:Document query = {title: "Inception"};
                var result = moviesCollection->find(query);
                if result is mongodb:Cursor {
                    bson:Document? doc = result.next();
                    while doc is bson:Document {
                        io:println("Retrieved Document: ", doc.toJsonString());
                        doc = result.next();
                    }
                } else {
                    io:println("Error occurred when retrieving the document: ", result.reason());
                }
            } else {
                io:println("Failed to retrieve collection: ", collectionResult.message());
                return collectionResult;
            }
        } else {
            io:println("Failed to retrieve database: ", dbResult.message());
            return dbResult;
        }

        // Step 5: Close the MongoDB client connection
        check mongoDb.close();
    } else {
        io:println("Failed to initialize MongoDB client: ", mongoDbResult.message());
        return mongoDbResult;
    }
}
