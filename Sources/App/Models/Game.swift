//
//  Game.swift
//  basicwebsitePackageDescription
//
//  Created by Kirby on 12/4/17.
//

import Foundation
import MongoKitten
import PerfectLib

// Make this crap better
class Game: JSONConvertibleObject {
    
    private struct JSONKey {
        static let name = "name"
        static let description = "description"
        static let image = "image"
        static let date = "date"
        static let developer = "developer"
        
        private init() {}
    }
    
    enum Error: Swift.Error {
        case parsingError(message: String)
    }
    
    static let collection = globalDataBase["game"]
    
    var id: ObjectId
    var name: String
    var description: String
    var image: String
    var date: String
    var developer: String
    
    
    var document: Document {
        
        
        return ["_id": id,
                "name": name,
                "description": description,
                "image": image,
                "date": date,
                "developer": developer]
    }
    
    init(name: String,
         description: String,
         image: String,
         date: String,
         developer: String) {
        
        self.id = ObjectId()
        self.name = name
        self.description = description
        self.image = image
        self.date = date
        self.developer = developer
    }
    
    convenience init(dictionary: [String: Any]) throws {
        guard let name = dictionary[JSONKey.name] as? String, !name.isEmpty else {
            throw Error.parsingError(message: "\(JSONKey.name) is not present!")
        }
        
        guard let description = dictionary[JSONKey.description] as? String, !description.isEmpty else {
            throw Error.parsingError(message: "\(JSONKey.description) is not present!")
        }
        
        guard let image = dictionary[JSONKey.image] as? String, !image.isEmpty else {
            throw Error.parsingError(message: "\(JSONKey.image) is not present!")
        }
        
        guard let date = dictionary[JSONKey.date] as? String, !date.isEmpty else {
            throw Error.parsingError(message: "\(JSONKey.date) is not present!")
        }
        
        guard let developer = dictionary[JSONKey.developer] as? String, !developer.isEmpty else {
            throw Error.parsingError(message: "\(JSONKey.developer) is not present!")
        }
        
        self.init(name: name, description: description, image: image, date: date, developer: developer)
    }
    
    // allows for encoding
    override func getJSONValues() -> [String : Any] {
        return [
            "id": id.hexString,
            "name": name,
            "description": description,
            "image": image,
            "date": date,
            "developer": developer
        ]
    }
    
    // MARK: - CRUD
    // TODO: Convert stuff below to game API
    // This is both create and update now
    func save() throws {
        
        let query: Query = "_id" == id
        
        // this only inserts
        //    Game.collection.insert(<#T##document: Document##Document#>)
        
        let documentForSave: Document = ["name": name,
                                         "description": description,
                                         "image": image,
                                         "date": date,
                                         "developer": developer]
        
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

