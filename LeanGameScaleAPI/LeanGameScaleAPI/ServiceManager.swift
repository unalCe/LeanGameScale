//
//  ServiceManager.swift
//  LeanGameScaleAPI
//
//  Created by Unal Celik on 1.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import Foundation


public enum APIError: String, Error {
    case invalidURL = "The URL is invalid"
    case invalidData = "The data is invalid"
    case invalidResponse = "The response is invalid"
    case decodingError = "Decoding failed"
}


public final class ServiceManager {
    
    static public let shared = ServiceManager()
    
    /// Current URLSession datatask that ServiceManager handling
    private var currentDataTask: URLSessionTask?
    
    // This ensures the singleton
    private init() { }
    
    public typealias ResponseHandler<T: Decodable> = (Result<T, Error>) -> Void
    
    private func requestData<T: Decodable>(fromEndpoint endpoint: APIEndpoints,
                                      completion: @escaping ResponseHandler<T>) {

        guard let url = endpoint.url else {
            #if DEBUG
            assertionFailure("URL invalid")
            #endif
            completion(.failure(APIError.invalidURL))
            return
        }

        // Cancel previous data task if there is one
        currentDataTask?.cancel()

        let request = URLRequest(url: url)

        currentDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion(.failure(error))
                return
            }

            // Check if the serer response is suitable
            guard let response = response as? HTTPURLResponse,
                (200..<300) ~= response.statusCode
                else {
                    completion(.failure(APIError.invalidResponse))
                    return
            }

            // Check if data exists
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }

            // Data is ready, decode it
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)

                // Update the results on the main thread
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch (let error){
                debugPrint(error)
                completion(.failure(APIError.decodingError))
            }
        }

        currentDataTask?.resume()
    }
}

// MARK: - Fetch Services
extension ServiceManager {

    // MARK: - All Games
    public func fetchAllGames(in page: Int, completion: @escaping ResponseHandler<BaseGamesResponse>) {
        requestData(fromEndpoint: .games(page), completion: completion)
    }

    // MARK: - Game Detail
    public func gameDetail(with gameId: Int, completion: @escaping ResponseHandler<Game>) {
        requestData(fromEndpoint: .gameDetail(gameId), completion: completion)
    }

    // MARK: - Search Games
    public func searchGames(with keyword: String, in page: Int = 1, completion: @escaping ResponseHandler<BaseGamesResponse>) {
        requestData(fromEndpoint: .searchGames(page, keyword), completion: completion)
    }

}
