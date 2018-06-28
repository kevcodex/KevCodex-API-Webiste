import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import MongoKitten

let globalApiKey = "27a9bec8-aa92-4a3f-800f-7618637d14a6"

var globalDataBase: Database!
var globalServer: HTTPServer!

public func start() throws {
    let server = KevCodex.server()
    var database: Database?
    
    do {
        database = try KevCodex.database()
        
    } catch {
        // Unable to connect to Mongo
        print("MongoDB is not available on the given host and port")
        let routeFail = Route(method: .get, uri: "/" , handler: { (request, response) in
            response.setBody(string: "MONGO FAIL: \(error)")
                .completed()
        })
        
        var routes = Routes()
        routes.add(routeFail)
        server.addRoutes(routes)
        
        try server.start()
    }
    
    globalServer = server
    globalDataBase = database
    
    try server.start()
}
