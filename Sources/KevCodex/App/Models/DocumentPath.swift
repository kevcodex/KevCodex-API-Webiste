//
//  DocumentPath.swift
//  basicwebsitePackageDescription
//
//  Created by Kirby on 1/29/18.
//

import Foundation

/// List of all the static file paths
enum DocumentPath {
    case Root
    case Pages
    
    var path: String {
        switch self {
            
        case .Root:
            return server.documentRoot
        case .Pages:
            return server.documentRoot + "/_pages"
        }
    }
}

