//
//  TestController.swift
//  basicwebsite
//
//  Created by Kevin Chen on 12/30/17.
//

import PerfectLib
import PerfectHTTP

final class TestController {
    
    var routes: Routes {
        return Routes(routesArray)
    }
    
    private var routesArray: [Route] {
        return [
            Route(method: .get, uri: "/hello", handler: hello),
            Route(method: .get, uri: "/beers/{num_beers}", handler: beers),
            Route(method: .get, uri: "/test/**", handler: staticRoute),
            Route(method: .put, uri: "/method/put", handler: putTest)
        ]
    }
    
    private func hello(request: HTTPRequest, response: HTTPResponse) {
        response.setBody(string: "HELLO PERFECT MAN AND WOMAN")
            .completed()
    }
    
    private func beers(request: HTTPRequest, response: HTTPResponse) {
        guard let numBeersString = request.urlVariables["num_beers"],
            let numBeersInt = Int(numBeersString) else {
                response.completed(status: .badRequest)
                return
        }
        returnJSONMessage(message: "Take one down, pass it around, \(numBeersInt - 1) bottles of beer on the wall...",
            response: response)
    }
    
    private func returnJSONMessage(message: String, response: HTTPResponse) {
        do {
            
            try response.setBody(json: ["message": message])
                .setHeader(.contentType, value: "application/json")
                .completed()
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
        
        
    }
    
    private func staticRoute(request: HTTPRequest, response: HTTPResponse) {
        
        // get the portion of the request path which was matched by the wildcard
        if let path = request.urlVariables[routeTrailingWildcardKey] {
            request.path = path
        }
        
        // Initialize the StaticFileHandler with a documentRoot
        let handler = StaticFileHandler(documentRoot: "webroot/_pages")
        
        // trigger the handling of the request,
        // with our documentRoot and modified path set
        handler.handleRequest(request: request, response: response)

    }
    
    private func putTest(request: HTTPRequest, response: HTTPResponse) {
        response.setBody(string: "Successfully routed to PUT")
            .completed()
    }
    
}
