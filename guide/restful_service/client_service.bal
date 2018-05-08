import ballerina/io;
import ballerina/http;
import ballerina/jdbc;
import ballerina/sql;

endpoint http:Listener listener {
    port:9090
};

endpoint jdbc:Client cip_db {
    url: "jdbc:mysql://localhost:3306/mydb",
    username: "root",
    password: "root",
    poolOptions: { maximumPoolSize: 20 }
};

type ClientsInfo {
    int id,
    string name,
};

@http:ServiceConfig { 
    basePath: "/client" 
}
service<http:Service> orderMgt bind listener {
    
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getClients"
    }
    getClient(endpoint client, http:Request req, string orderId) {
    var selectClientRet = cip_db->select("SELECT ID,NAME FROM CLIENT", ClientsInfo);
    table<ClientsInfo> clientsInfoDataTable;
    match selectClientRet {
        table tableReturned => clientsInfoDataTable = tableReturned;
        error e => io:println("Select data from client table failed: " + e.message);
    }
    var jsonConversionRet = <json>clientsInfoDataTable;
    }
}