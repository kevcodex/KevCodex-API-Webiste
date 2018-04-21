import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import MongoKitten
import Foundation

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
    
    do {
        try server.start()
    } catch PerfectError.networkError(let error, let msg) {
        print("NETWORK error \(error), \(msg)")
    }
    
}



do {
    try server.start()
} catch PerfectError.networkError(let error, let msg) {
    print("NETWORK error \(error), \(msg)")
}

