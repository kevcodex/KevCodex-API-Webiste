//
//  KevCodexServer.swift
//  App
//
//  Created by Kirby on 4/21/18.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

class KevCodexServer {
    static func server() -> HTTPServer {
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
