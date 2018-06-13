//
//  GameServiceLayer.swift
//  App
//
//  Created by Kirby on 6/5/18.
//

import Foundation
import MongoKitten
import PerfectLib

/// The API layer for saving games into the Mongo Database
// TODO: - consider making this non static? Also maybe make protocol? 
class GameServiceLayer {
    
    static let collection = globalDataBase["game"]
    
    // MARK: - CRUD
    static func save(_ game: Game) throws {
        
        let query: Query = "_id" == game.id
        
        // this only inserts
        //    Game.collection.insert()
        
        let documentForSave: Document = ["name": game.name,
                                         "description": game.description,
                                         "image": game.image,
                                         "date": game.date,
                                         "developer": game.developer]
        
        // update can insert and update
        try GameServiceLayer.collection.update(query,
                                               to: documentForSave,
                                               upserting: true)
    }
    
    // TODO - Put parsing in Game? 
    static func find(id: String) throws -> Game {
        let objectID = try ObjectId(id)
        
        let query: Query = "_id" == objectID
        
        guard let gameDocument = try GameServiceLayer.collection.findOne(query) else {
            throw MongoError.couldNotHashFile
        }
        
        let dictionary = gameDocument.dictionaryRepresentation as [String: Any]
        
        guard let id = dictionary["_id"] as? ObjectId else {
            throw MongoError.couldNotHashFile
        }
        
        let game = try Game(dictionary: dictionary)
        game.id = id
        
        return game
    }
    
    
    static func find(name: String) throws -> Game  {
        let query: Query = "name" == name
        
        guard let gameDocument = try GameServiceLayer.collection.findOne(query) else {
            throw MongoError.couldNotHashFile
        }
        
        let dictionary = gameDocument.dictionaryRepresentation as [String: Any]
        
        guard let id = dictionary["_id"] as? ObjectId else {
            throw MongoError.couldNotHashFile
        }
        
        let game = try Game(dictionary: dictionary)
        game.id = id
        
        return game
    }
    
    static func findAll() throws -> [Game] {
        
        let gameDocuments = try GameServiceLayer.collection.find()
        
        var games: [Game] = []
        for gameDocument in gameDocuments {
            let dictionary = gameDocument.dictionaryRepresentation as [String: Any]
            
            guard let id = dictionary["_id"] as? ObjectId else {
                throw MongoError.couldNotHashFile
            }
            
            let game = try Game(dictionary: dictionary)
            game.id = id
            
            games.append(game)
            
        }
        
        return games
    }
    
    
    static func delete(name: String) throws {
        let query: Query = "name" == name
        
        guard let _ = try GameServiceLayer.collection.findOne(query) else {
            throw MongoError.unsupportedFeature("Could not find \(name)")
        }
        
        try GameServiceLayer.collection.remove(query)
    }
}
