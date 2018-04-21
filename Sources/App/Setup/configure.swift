import MongoKitten
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

let globalApiKey = "27a9bec8-aa92-4a3f-800f-7618637d14a6"

var globalDataBase: Database!
var globalServer: HTTPServer!

public class Backend {
    
    public init() {
        
    }
    
    public func start() throws {
        let server = configureServer()
        var database: Database!
        
        do {
            database = try configureDatabase()
            
        } catch {
            // Unable to connect
            print("MongoDB is not available on the given host and port")
            let routeFail = Route(method: .get, uri: "/" , handler: { (request, response) in
                response.setBody(string: "MONGO FAIL")
                    .completed()
            })
            
            var routes = Routes()
            routes.add(routeFail)
            server.addRoutes(routes)
            
            try server.start()
        }
        
        try server.start()
        globalServer = server
        globalDataBase = database
    }
    
    private func configureDatabase() throws -> Database {
        // Start mongo DB
        // Need to have Mongod running
        var mongodb: Server!
        
        guard let dbURI = ProcessInfo.processInfo.environment["DB_URI"] else {
            throw MongoError.noServersAvailable
        }
        
        mongodb = try Server(dbURI)
        
        return mongodb["local"]
    }
    
    private func configureServer() -> HTTPServer {
        
        let server = HTTPServer()
        server.serverPort = 8080
        server.documentRoot = "webroot"
        
        
        let testController = TestController()
        server.addRoutes(testController.routes)
        
        let gameController = GameController()
        server.addRoutes(gameController.routes)
        
        let blah: [(HTTPRequestFilter, HTTPFilterPriority)] = [(Test(), HTTPFilterPriority.high)]
        
        server.setRequestFilters(blah)
        
        return server
        
    }
}



