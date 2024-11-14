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
            .decode(type: MarvelCharacterResponse.self, decoder: JSONDecoder())
            .map { response in
                return response.data.results
            }
            .map { characters in
                return characters as! T
            }
            .mapError { error in
                print("Decoding error: \(error)")
                return NetworkError.mapError(error)
            }
            .eraseToAnyPublisher()
    }
}
