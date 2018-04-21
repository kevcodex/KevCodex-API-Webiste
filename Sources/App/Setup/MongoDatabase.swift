//
//  MongoDatabase.swift
//  App
//
//  Created by Kirby on 4/21/18.
//

import Foundation
import MongoKitten

class MongoDatabase {
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
