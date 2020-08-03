//
//  APIEndpoints.swift
//  LeanGameScaleAPI
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation


// Örnek url: https://api.rawg.io/api/games?page_size=10&page=1&search=gtav

public enum APIEndpoints {
    case gameDetail(_ gameId: Int)
    case games(_ page: Int)
    case searchGames(_ page: Int, _ keyword: String)
}

extension APIEndpoints {
    
    public var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.rawg.io"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
    
    private var path: String {
        switch self {
        case .gameDetail(let gameId):
            return "/api/games/\(gameId)"
            
        case .games, .searchGames:
            return "/api/games"
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .games(let page):
            return queryParameters(page)
        case .searchGames(let page, let keyword):
            return queryParameters(page, keyword)
        default:
            return nil
        }
    }
    
    private func queryParameters(_ page: Int,
                                 _ keyword: String? = nil) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "page_size", value: "10"))  // This accepted as default
        items.append(URLQueryItem(name: "page", value: "\(page)"))
        
        if keyword != nil {
            items.append(URLQueryItem(name: "search", value: keyword!))
        }
        
        return items
    }
}
