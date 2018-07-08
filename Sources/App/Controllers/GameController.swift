//
//  GameController.swift
//  basicwebsitePackageDescription
//
//  Created by Kevin Chen on 12/30/17.
//

import PerfectLib
import PerfectHTTP

final class GameController {

    var routes: Routes {
        return Routes(routesArray)
    }
    
    // TODO: - modify API to match swagger spec
    private var routesArray: [Route] {
        return [
            Route(method: .get, uri: "/", handler: main),
            Route(method: .get, uri: "/games", handler: getGame),
            Route(method: .post, uri: "/games", handler: saveGame),
            Route(method: .get, uri: "/games/name/{name}", handler: getGameByName),
            Route(method: .delete, uri: "/games/name/{name}", handler: deleteGameByName)
        ]
    }
    
    
    // MARK: - Main
    private func main(request: HTTPRequest, response: HTTPResponse) {
        StaticFileHandler(documentRoot: request.documentRoot).handleRequest(request: request, response: response)        
    }
    
    
    // MARK: - Get Game(s)
    private func getGame(request: HTTPRequest, response: HTTPResponse) {
        
        if let jsonQuery = request.param(name: QueryParameter.json.key),
            jsonQuery.lowercased() == "true" {
            
            do {
                let games = try GameServiceLayer.findAll()
                
                let string = try games.jsonEncodedString()
                
                response.setBody(string: string)
                    .completed()
                
            } catch {
                response.setBody(string: "Error handling request: \(error)")
                    .completed(status: .internalServerError)
            }
            
            return
        }
        
        // Show all games in web list
        // TODO: - use mustache or some view renderer to show games
        do {
            let games = try GameServiceLayer.findAll()
            
            var string = "My Favorite games are: "
            
            for game in games {
                string += "\(game.name), "
            }
            
            response.setBody(string: string)
                .completed()
            
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
    
    // MARK: - Save Game
    private func saveGame(request: HTTPRequest, response: HTTPResponse) {
        guard let apiKey = checkHeader(for: .apiKey, request: request, response: response) else {
            return
        }
        
        guard apiKey == globalApiKey else {
            response.setBody(string: "Invalid API Key")
                .completed(status: .unauthorized)
            
            return
        }
        
        do {
            guard let json = try request.postBodyString?.jsonDecode() as? [String: Any] else {
                throw JSONConversionError.syntaxError
            }
            
            let game = try Game(dictionary: json)
            try GameServiceLayer.save(game)
            
            response.setBody(string: "Created game named: \(game.name)")
                .completed()
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .notFound)
        }
    }
    
    // MARK: - Get Game From Name
    private func getGameByName(request: HTTPRequest, response: HTTPResponse) {
        
        guard let nameString = request.urlVariables["name"] else {
            response.completed(status: .badRequest)
            return
        }

        do {
            let game = try GameServiceLayer.find(name: nameString)
            
            response.setBody(string: "Found game with id: \(game.id), named \(game.name)")
                .completed()
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
    
    // MARK: - Get Game From ID
    private func getGameFromID(request: HTTPRequest, response: HTTPResponse) {
        guard let objectIDString = request.urlVariables["objectid"] else {
                response.completed(status: .badRequest)
                return
        }
        
        do {
            let game = try GameServiceLayer.find(id: objectIDString)
            
            response.setBody(string: "Game is named \(game.name)")
                .completed()
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
    
    // MARK: - Get Game JSON
    private func getGameJson(request: HTTPRequest, response: HTTPResponse) {
        do {
            let games = try GameServiceLayer.findAll()
            
            let string = try games.jsonEncodedString()
            
            response.setBody(string: string)
                .completed()
            
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
    
    // MARK: - Delete Game
    private func deleteGameByName(request: HTTPRequest, response: HTTPResponse) {
        guard let apiKey = checkHeader(for: .apiKey, request: request, response: response) else {
            return
        }
        
        guard apiKey == globalApiKey else {
            response.setBody(string: "Invalid API Key")
                .completed(status: .unauthorized)
            
            return
        }
        
        guard let nameString = request.urlVariables["name"] else {
            response.completed(status: .badRequest)
            return
        }
        
        do {
            try GameServiceLayer.delete(name: nameString)
            
            response.setBody(string: "\(nameString) successfully deleted")
                .completed()
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .notFound)
        }
    }
    
    // MARK: - Helpers
    
    private func checkHeader(for type: Header, request: HTTPRequest, response: HTTPResponse) -> String? {
        guard let header = request.header(.custom(name: "apikey")) else {
            response.setBody(string: "\(type.body)")
                .completed(status: .unauthorized)
            
            return nil
        }
        
        return header
    }
    
    private func checkParameter(for type: QueryParameter, request: HTTPRequest, response: HTTPResponse) -> String? {
        guard let parameter = request.param(name: type.key) else {
            response.setBody(string: "\(type.string) Missing")
                .completed(status: .unauthorized)
            
            return nil
        }
        
        return parameter
    }
}

// MARK: - Header
extension GameController {
    enum Header {
        case apiKey
        
        var key: String {
            switch self {
                
            case .apiKey:
                return "apikey"
            }
        }
        
        var body: String {
            switch self {
            case .apiKey:
                return "API Key is missing!"
            }
        }
    }
}

// MARK: - Query Parameter
extension GameController {
    enum QueryParameter {
        case name
        case description
        case image
        case date
        case developer
        case json
        
        var key: String {
            switch self {
                
            case .name:
                return "name"
            case .description:
                return "description"
            case .image:
                return "image"
            case .date:
                return "date"
            case .developer:
                return "developer"
            case .json:
                return "json"
                
            }
        }
        
        var string: String {
            switch self {
            case .name:
                return "Name Parameter"
            case .description:
                return "Description Parameter"
            case .image:
                return "Image Parameter"
            case .date:
                return "Date Parameter"
            case .developer:
                return "Developer Parameter"
            case .json:
                return "json"
            }
        }
    }
}
