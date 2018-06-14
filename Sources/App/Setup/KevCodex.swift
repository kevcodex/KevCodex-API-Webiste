//
//  KevCodex.swift
//  App
//
//  Created by Kirby on 4/21/18.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectWebRedirects
import MongoKitten

class KevCodex {
    static func server() -> HTTPServer {
        let server = HTTPServer()
        server.serverPort = 8080
        server.documentRoot = "webroot"
        
        
        let testController = TestController()
        server.addRoutes(testController.routes)
        
        let gameController = GameController()
        server.addRoutes(gameController.routes)
        
        //        let filters: [(HTTPRequestFilter, HTTPFilterPriority)] = [(Test(), HTTPFilterPriority.high)]
        //        server.setRequestFilters(filters)
        
        var filters = [(HTTPRequestFilter, HTTPFilterPriority)]()
        
        let methodOverrideFilter: (HTTPRequestFilter, HTTPFilterPriority) = (MethodOverrideFilter(), HTTPFilterPriority.high)
        
        filters.append(methodOverrideFilter)
        
        do {
            let redirectRequestFilter = try WebRedirectsFilter.filterAPIRequest(data: [:])
            let redirectFilter: (HTTPRequestFilter, HTTPFilterPriority) = (redirectRequestFilter, HTTPFilterPriority.high)
            filters.append(redirectFilter)
        } catch {
            fatalError()
        }
        
        server.setRequestFilters(filters)
        
        return server
    }
    
    static func database() throws -> Database {
        // Start mongo DB
        // Need to have Mongod running
        var mongodb: Server!
        
        guard let dbURI = ProcessInfo.processInfo.environment["DB_URI"] else {
            throw MongoError.noServersAvailable
        }
        
        mongodb = try Server(dbURI)
        
        return mongodb["local"]
    }
}
