import ballerina/http;
import ballerina/io;

// Define a record type for User
type User readonly & record {|
    string name;
    int age;
    string email;
|};

// Create a table to store users
table<User> key(name) users = table [];

// Define the HTTP service
service / on new http:Listener(9090) {

    // Resource function to get all users
    resource function get users() returns User[] {
        return users.toArray();
    }

    // Resource function to add a new user
    resource function post users(User user) returns User {
        users.add(user);
        io:println("User added: " + user.toString());
        return user;
    }
}