//
//  Game.swift
//  basicwebsitePackageDescription
//
//  Created by Kirby on 12/4/17.
//

import Foundation
import MongoKitten
import PerfectLib

/// The model of the game objects.
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
    
    var id: ObjectId
    var name: String
    var description: String
    var image: String
    var date: String
    var developer: String
    
    init(dictionary: [String: Any]) throws {
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
        
        self.id = ObjectId()
        self.name = name
        self.description = description
        self.image = image
        self.date = date
        self.developer = developer
    }
    
    // Allows for encoding
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
}

