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
