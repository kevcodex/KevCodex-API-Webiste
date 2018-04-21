import MongoKitten
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

let globalApiKey = "27a9bec8-aa92-4a3f-800f-7618637d14a6"


public func configureDatabase() throws -> Database {
    // Start mongo DB
    // Need to have Mongod running
    var mongodb: Server!
    
    guard let dbURI = ProcessInfo.processInfo.environment["DB_URI"] else {
        throw MongoError.noServersAvailable
    }
    
    mongodb = try Server(dbURI)
    
    return mongodb["local"]
}

public func configureServer() -> HTTPServer {
    
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




