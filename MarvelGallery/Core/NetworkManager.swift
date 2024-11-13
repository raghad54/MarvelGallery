//
//  NetworkManager.swift
//  MarvelGallery
//
//  Created by Raghad's Mac on 13/11/2024.
//

import Foundation
import Combine

protocol NetworkManaging {
    func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error>
}

class NetworkManager: NetworkManaging {
    private let session: URLSession
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.session = URLSession.shared
    }
    
    func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        let request = URLRequest(url: url)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: MarvelCharacterResponse.self, decoder: JSONDecoder()) // Decode the root response
            .map { response in
                return response.data.results // Extract and return the 'results' array from the 'data' field
            }
            .map { characters in
                // Now characters will be of type [CharacterListModel]
                return characters as! T // Cast to the generic type
            }
            .mapError { error in
                // Log the error to help debug
                print("Decoding error: \(error)")
                return NetworkError.mapError(error)
            }
            .eraseToAnyPublisher()
    }


}


enum NetworkError: Error {
    case badServerResponse
    case decodingError
    case unknownError
    
    static func mapError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            return .badServerResponse
        } else if error is DecodingError {
            return .decodingError
        } else {
            return .unknownError
        }
    }
}
