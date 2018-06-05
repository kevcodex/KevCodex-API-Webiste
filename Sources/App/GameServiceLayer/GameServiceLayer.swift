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
class GameServiceLayer {
    
    // MARK: - CRUD
    static func save(_ game: Game) throws {
        
        let query: Query = "_id" == game.id
        
        // this only inserts
        //    Game.collection.insert(<#T##document: Document##Document#>)
        
        let documentForSave: Document = ["name": game.name,
                                         "description": game.description,
                                         "image": game.image,
                                         "date": game.date,
                                         "developer": game.developer]
        
        // update can insert and update
        try Game.collection.update(query,
                                   to: documentForSave,
                                   upserting: true)
    }
    
    static func find(id: String) throws -> Game {
        let objectID = try ObjectId(id)
        
        let query: Query = "_id" == objectID
        
        guard let gameDocument = try Game.collection.findOne(query) else {
            throw MongoError.couldNotHashFile
        }
        
        guard let name = gameDocument.dictionaryRepresentation["name"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        guard let description = gameDocument.dictionaryRepresentation["description"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        guard let image = gameDocument.dictionaryRepresentation["image"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        guard let date = gameDocument.dictionaryRepresentation["date"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        guard let developer = gameDocument.dictionaryRepresentation["developer"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        
        guard let id = gameDocument.dictionaryRepresentation["_id"] as? ObjectId else {
            throw MongoError.couldNotHashFile
        }
        
        let game = Game(name: name, description: description, image: image, date: date, developer: developer)
        game.id = id
        
        return game
    }
    
    
    static func find(name: String) throws -> Game  {
        let query: Query = "name" == name
        
        guard let gameDocument = try Game.collection.findOne(query) else {
            throw MongoError.couldNotHashFile
        }
        
        
        guard let name = gameDocument.dictionaryRepresentation["name"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        guard let description = gameDocument.dictionaryRepresentation["description"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        guard let image = gameDocument.dictionaryRepresentation["image"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        guard let date = gameDocument.dictionaryRepresentation["date"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        guard let developer = gameDocument.dictionaryRepresentation["developer"] as? String else {
            throw MongoError.couldNotHashFile
        }
        
        
        guard let id = gameDocument.dictionaryRepresentation["_id"] as? ObjectId else {
            throw MongoError.couldNotHashFile
        }
        
        
        let game = Game(name: name, description: description, image: image, date: date, developer: developer)
        game.id = id
        
        return game
    }
    
    static func findAll() throws -> [Game] {
        
        let gameDocuments = try Game.collection.find()
        
        var games: [Game] = []
        for gameDocument in gameDocuments {
            guard let name = gameDocument.dictionaryRepresentation["name"] as? String else {
                throw MongoError.couldNotHashFile
            }
            
            guard let description = gameDocument.dictionaryRepresentation["description"] as? String else {
                throw MongoError.couldNotHashFile
            }
            
            guard let image = gameDocument.dictionaryRepresentation["image"] as? String else {
                throw MongoError.couldNotHashFile
            }
            
            guard let date = gameDocument.dictionaryRepresentation["date"] as? String else {
                throw MongoError.couldNotHashFile
            }
            
            guard let developer = gameDocument.dictionaryRepresentation["developer"] as? String else {
                throw MongoError.couldNotHashFile
            }
            
            
            guard let id = gameDocument.dictionaryRepresentation["_id"] as? ObjectId else {
                throw MongoError.couldNotHashFile
            }
            
            let game = Game(name: name, description: description, image: image, date: date, developer: developer)
            game.id = id
            
            games.append(game)
            
        }
        
        return games
    }
    
    
    static func delete(name: String) throws {
        let query: Query = "name" == name
        
        guard let _ = try Game.collection.findOne(query) else {
            throw MongoError.unsupportedFeature("Could not find \(name)")
        }
        
        try Game.collection.remove(query)
    }
}
