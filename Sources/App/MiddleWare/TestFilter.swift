//
//  TestFilter.swift
//  App
//
//  Created by Kirby on 4/21/18.
//

import PerfectHTTP

struct Test: HTTPRequestFilter {
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        request.method = .get
        request.addHeader(.custom(name: "dadwad"), value: "adwdawawd")
        callback(.execute(request, response))
    }
}

struct MethodOverrideFilter: HTTPRequestFilter {
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        if let methodParam = request.param(name: "_method")?.uppercased(),
            let newMethod = httpMethod(from: methodParam) {
            
            request.method = newMethod
            
            callback(.execute(request, response))
        } else {
            
            callback(.execute(request, response))
        }
    }
    
    private func httpMethod(from string: String) -> HTTPMethod? {
        switch string {
        case "OPTIONS":
            return .options
        case "GET":
            return .get
        case "HEAD":
            return .head
        case "POST":
            return .post
        case "PATCH":
            return .patch
        case "PUT":
            return .put
        case "DELETE":
            return .delete
        case "TRACE":
            return .trace
        case "CONNECT":
            return .connect
        default:
            return nil
        }
    }
}
