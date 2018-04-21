//
//  GameController.swift
//  basicwebsitePackageDescription
//
//  Created by Kevin Chen on 12/30/17.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

final class GameController {
    
    enum Parameter {
        case apiKey
        case name
        case description
        case image
        case date
        case developer
        
        var key: String {
            switch self {
                
            case .apiKey:
                return "apikey"
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
            
            }
        }
        
        var string: String {
            switch self {
                
            case .apiKey:
                return "Api Key"
            case .name:
                return "Name Parameter"
            case .description:
                return "Description Parameter"
            case .image:
                return "Image Parameter"
            case .date:
                return "Date Parameter"
            case .developer:
                return "Devevloper Parameter"
            }
        }
    }
    
    var routes: Routes {
        return Routes(routesArray)
    }
    
    private var routesArray: [Route] {
        return [
            Route(method: .get, uri: "/", handler: main),
            Route(method: .get, uri: "/game", handler: getGame),
            Route(method: .post, uri: "/game", handler: saveGame),
            Route(method: .get, uri: "/game-id", handler: getGameFromID),
            Route(method: .get, uri: "/game-json", handler: getGameJson),
            Route(method: .post, uri: "/game-delete", handler: deleteGame)
        ]
    }
    
    
    // MARK: - Main
    private func main(request: HTTPRequest, response: HTTPResponse) {
        StaticFileHandler(documentRoot: request.documentRoot).handleRequest(request: request, response: response)        
    }
    
    
    // MARK: - Get Game(s)
    private func getGame(request: HTTPRequest, response: HTTPResponse) {
        
        // view a specific game
        if let name = request.header(.custom(name: "name")) {
            
            do {
                let game = try Game.find(name: name)
                
                response.setBody(string: "Found game with id: \(game.id), named \(game.name)")
                    .completed()
            } catch {
                response.setBody(string: "Error handling request: \(error)")
                    .completed(status: .internalServerError)
            }
            
        } else {
            // show all games
            
            do {
                let games = try Game.findAll()
                
                var string = "My Favorite games are: "
                
                for game in games {
                    string += "\(game.name), "
                    
                    let test = try game.jsonEncodedString()
                    
                    print(test)
                }
                
                response.setBody(string: string)
                    .completed()
                
            } catch {
                response.setBody(string: "Error handling request: \(error)")
                    .completed(status: .internalServerError)
            }
        }
    }
    
    // MARK: - Save Game
    private func saveGame(request: HTTPRequest, response: HTTPResponse) {
        guard let apiKey = checkParameter(for: .apiKey, request: request, response: response) else {
            return
        }
        
        guard apiKey == globalApiKey else {
            response.setBody(string: "Invalid API Key")
                .completed(status: .custom(code: 400, message: "Invalid"))
            
            return
        }
        
        guard let name = checkParameter(for: .name, request: request, response: response) else {
            return
        }
        
        guard let description = checkParameter(for: .description, request: request, response: response) else {
            return
        }
        
        guard let image = checkParameter(for: .image, request: request, response: response) else {
            return
        }
        
        guard let date = checkParameter(for: .date, request: request, response: response) else {
            return
        }
        
        guard let developer = checkParameter(for: .developer, request: request, response: response) else {
            return
        }
        
        guard !name.isEmpty, !description.isEmpty, !image.isEmpty, !date.isEmpty, !developer.isEmpty else {
            response.setBody(string: "Params Cannot Be Empty")
                .completed(status: .custom(code: 402, message: "Empty"))
            
            return
        }
        
        do {
            let game = Game(name: name, description: description, image: image, date: date, developer: developer)
            try game.save()
            
            response.setBody(string: "Created game named: \(game.name)")
                .completed()
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
    
    // MARK: - Get Game From ID
    private func getGameFromID(request: HTTPRequest, response: HTTPResponse) {
        guard let id = request.header(.custom(name: "id")) else {
            response.setBody(string: "ID header Missing")
                .completed(status: .custom(code: 401, message: "ID header Missing"))
            
            return
        }
        
        do {
            let game = try Game.find(id: id)
            
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
            let games = try Game.findAll()
            
            let string = try games.jsonEncodedString()
            
            response.setBody(string: string)
                .completed()
            
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
    
    // MARK: - Delete Game
    private func deleteGame(request: HTTPRequest, response: HTTPResponse) {
        guard let apiKey = checkParameter(for: .apiKey, request: request, response: response) else {
            return
        }
        
        guard apiKey == globalApiKey else {
            response.setBody(string: "Invalid API Key")
                .completed(status: .custom(code: 400, message: "Invalid"))
            
            return
        }
        
        guard let name = checkParameter(for: .name, request: request, response: response) else {
            return
        }
        
        do {
            try Game.delete(name: name)
            
            response.setBody(string: "\(name) successfully deleted")
                .completed()
        } catch {
            response.setBody(string: "Error handling request: \(error)")
                .completed(status: .internalServerError)
        }
    }
    
    // MARK: - Helpers
    
    private func checkParameter(for type: Parameter, request: HTTPRequest, response: HTTPResponse) -> String? {
        guard let parameter = request.param(name: type.key) else {
            response.setBody(string: "\(type.string) Missing")
                .completed(status: .custom(code: 401, message: "Parameter Missing"))
            
            return nil
        }
        
        return parameter
    }
}
